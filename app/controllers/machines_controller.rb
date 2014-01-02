class MachinesController < ApplicationController
  def create
    @image = Image.find_by_id(params[:id])
    @machine = Machine.new(:remote_username => "a", :remote_password => "a")
    @machine.image = @image
    if @machine.save
      redirect_to @machine, notice: 'Machine launcheda'
    else
      redirect_to root_path, error: 'Error launching machine' 
    end
  end

  def show
    @machine = Machine.find_by_id(params[:id])
  end
end
