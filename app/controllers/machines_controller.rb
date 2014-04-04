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
    end
  end

  def create
    @fakemachine = Machine.new
    authorize @fakemachine
    @machine, @ready_machine = Machine.launch(Image.find_by_id(params.require(:id)))
    @ready_machine.user = current_user
    # TODO: Añadir ip flotante
    @ready_machine.save
    if @machine.save
      StartMachine.perform_async(@machine.id)
      redirect_to @ready_machine, notice: 'Machine was successfully created.' 
    else
      redirect_to root_path
    end
  end

  def destroy
    authorize @machine
    # TODO: Quitar ip flotante
    @machine.cloud_destroy
    rescue Timeout::Error => e
      @mensaje_error = "Machine has been deleted from database, but there is no connection with cloud. YOU SHOULD DELETE THIS VM MANUALLY FROM THE CLOUD. Reason: #{e}. #{@machine.cloud_server.description} - #{@machine.id}"
      @machine.destroy
      redirect_to root_path, notice: @mensaje_error 
    rescue Errno::ECONNREFUSED 
      @mensaje_error = "Machine has been deleted from database, but there is no connection with cloud. YOU SHOULD DELETE THIS VM MANUALLY FROM THE CLOUD. Reason: Connection refused. #{@machine.cloud_server.description} - #{@machine.id}"
      @machine.destroy
      redirect_to root_path, notice: @mensaje_error 
    
    rescue TypeError => e
      @mensaje_error = "Machine has been deleted from database, but there isn't a machine with id #{@machine.id} in #{@machine.cloud_server.description}"
      @machine.destroy     
      redirect_to root_path, notice: @mensaje_error
    rescue
      @mensaje_error = "  Machine has been deleted from database, but there is an error deleting  machine with id #{@machine.id} in #{@machine.cloud_server.description}. Please, do it manually"
      @machine.destroy
      redirect_to root_path, notice: @mensaje_error
    else 
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
