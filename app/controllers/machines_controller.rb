class MachinesController < ApplicationController
  before_action :set_machine, only: [:show, :destroy, :reboot]

  def index
    @machines = Machine.all
    authorize @machines
 end

  def show
    authorize @machine
    respond_to do |format|
      format.html
      format.rdp { render rdp: @machine.to_s, :template => 'machines/show.rdp.erb' }
      format.vnc { render vnc: @machine.to_s, :template => 'machines/show.vnc.erb' }
    end
  end

  def create
    @fakemachine = Machine.new
    authorize @fakemachine
    @machine, @ready_machine = Machine.launch(Image.find_by_id(params.require(:id)))
    @ready_machine.user = current_user
    @ready_machine.save
    if @machine.save
      @machine.cloud_create
      sleep 5
      @machine.pause
      redirect_to @ready_machine, notice: 'Machine was successfully created.' 
    else
      redirect_to root_path
    end
  end

  def destroy
    authorize @machine
    @machine.cloud_destroy
    @machine.destroy
    redirect_to root_path
  end

  def reboot
    authorize @machine
    @machine.reboot
    redirect_to root_path, notice: ' Machine has been rebooted.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_machine
      @machine = Machine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def machine_params
      params.require(:machine).permit(:image_id, :user_id, :remote_username, :remote_password, :remote_address, :remote_port)
    end
end
