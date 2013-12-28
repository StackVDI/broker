class AdministrationController < ApplicationController
  before_action :auth

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
    authorize self
    @user = User.find(params[:id])
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
    @user = User.find(params[:id])  
  end

  def update_user
    redirect_to administration_list_users_path
  end

  private
    def auth
      authorize self
    end
end
