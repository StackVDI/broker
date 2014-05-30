require 'csv'
require 'set'
require 'fileutils'

class AdministrationController < ApplicationController

  def list_users
    authorize self
    @users = User.all
  end

 def toggle_approved_user 
    authorize self
    @user = User.find(params[:id])
    @user.toggle_approved!
    if @user.save
      redirect_to administration_list_users_path
    else
      redirect_to administration_list_users_path, alert: "Error updating approvation"
    end
  end

  def delete_user 
    @user = User.find(params[:id])
    authorize @user
    @user.destroy
    redirect_to administration_list_users_path
  end

  def list_groups
    authorize self
    @groups = Role.all
  end

  def users_from_group
   authorize self
   @role = Role.find(params[:id])
   @users = @role.users
  end

  def edit_user
    authorize self
    @user = User.find(params[:id])  
  end

  def update_user
    authorize self
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to administration_list_users_path
    else
      redirect_to administration_list_users_path, alert: "Error updating user"
    end
  end

  def upload_csv
    authorize self
    
  end

  def check_file
    # We check the file:
    #  * CSV file structure.
    #  * The users in the file MUST NOT exist.
    #  * The users MUST NOT be repeated in the file.
    #  * The role field format MUST BE correct.
    #  * The roles MUST exist.

    authorize self

    if not params[:upload]

      redirect_to administration_upload_csv_path, alert: "No file provided, upload a right file!!"
      return
    end

    @CSV_errors = Array.new
    @data_errors = Array.new
    @role_errors = Array.new
    my_file = params[:upload]
    @users = Set.new
    line_number = 1
    @users_to_create = 0
    @file_is_correct = false
    CSV.open(my_file.path) do |output|
      loop do
        begin
          break unless row = output.shift
          error = false
          email = row[0]
          user = User.find_by(email: email)
          if user != nil
            @data_errors << "line #{line_number}: the mail #{email} already exists"
            error = true
          end
          if @users.include?(email)
            @data_errors << "line #{line_number}: the mail #{email} is repeated"
            error = true
          else
            @users << email
          end
          roles = row[3].split(",")
          roles.each do |r|
            role = Role.find_by(name: r) 
            if role == nil
              @role_errors << "line #{line_number}: the role #{r} doesn't exist"
              error = true
            end
          end
          line_number += 1
          if not error
            @users_to_create += 1
          end
        rescue CSV::MalformedCSVError => e
          @CSV_errors << "CSV error in line #{line_number}"
          line_number += 1
        end
      end   
    end

    if @CSV_errors.empty? and @data_errors.empty? and @role_errors.empty?
      @file_is_correct = true
      path = "#{Rails.root}/tmp/" + (0...8).map { (65 + rand(26)).chr }.join
      FileUtils.cp(my_file.path, path)
      session[:my_file] = path
    end
  end

  def create_users
    authorize self
    @my_file = session[:my_file]
    if @my_file == nil
      redirect_to administration_upload_csv_path, alert: "You must provide a CSV file"
      return
    end
    session[:my_file] = nil
    @users_created = 0
    line_number = 1
    begin
      User.transaction do
        CSV.open(@my_file) do |output|
          loop do
            begin
              break unless row = output.shift
              user = User.new
              user.email = row[0]
              user.last_name = row[1]
              user.first_name = row[2]
              roles = row[3].split(',')
              roles.each do |r|
                role_to_find = Role.find_by(name: r)
                user.roles << role_to_find
              end
              temp_password = (0...8).map { (65 + rand(26)).chr }.join
              user.password = temp_password
              user.password_confirmation = temp_password
              line_number += 1    
              #user.confirm!
              user.confirmed_at = Time.now
              user.approved = true
              user.save
              @users_created += 1
            rescue CSV::MalformedCSVError => e
              # This will never happen
              @CSV_errors << "CSV error in line #{line_number}"
              line_number += 1
              raise
            end
          end
        end
      end
    rescue
      @error = "Transaction aborted"
    end
    FileUtils.remove_file(@my_file)
    flash[:notice] = "#{@users_created} #{'user'.pluralize(@users_created)} created"
  end

  private
    def user_params
       params.require(:user).permit(:first_name, :last_name, :role_ids => [])
    end

end
