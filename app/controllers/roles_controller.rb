class RolesController < ApplicationController

  before_action :set_role, only: [:edit, :update, :destroy]

  def new
    @role = Role.new
    authorize @role
  end

  def create
    @role = Role.new(role_params)
    authorize @role
    if @role.save
      redirect_to administration_list_groups_path, notice: 'Role successfully created.'
    else
      render action: 'new'
    end
  end

  def edit
    authorize @role
  end

  def update
    authorize @role
    if @role.update(role_params)
      redirect_to administration_list_groups_path, notice: 'Role was successfully updated.' 
    else
      render action: 'edit' 
    end
  end

  def destroy
    authorize @role
    @role.destroy 
    redirect_to administration_list_groups_path, notice: 'Role deleted.'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_role
    @role = Role.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
    def role_params
      params.require(:role).permit(:name, :machine_lifetime, :machine_idletime)
    end
end
