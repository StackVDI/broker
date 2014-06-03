class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy ]

  def show
    authorize @image
  end

  # GET /images
  def index
    @cloud_server = CloudServer.find(params[:cloud_server_id])   
    @images = @cloud_server.images
    authorize @images
  end

  # GET /images/new
  def new
    @cloud_server = CloudServer.find(params[:cloud_server_id])
    @machines = @cloud_server.machines
    @flavors = @cloud_server.flavors
    @image = Image.new
    @image.cloud_server = @cloud_server
    authorize @image
  end

  # GET /images/1/edit
  def edit
    authorize @image
    @cloud_server = CloudServer.find(params[:cloud_server_id])
    @machines = @cloud_server.machines
    @flavors = @cloud_server.flavors
  end

  # POST /images
  def create
    @cloud_server = CloudServer.find(params[:cloud_server_id])
    @image = Image.new(image_params)
    @image.cloud_server = CloudServer.find(params[:cloud_server_id])
    authorize @image
    if @image.save
      (@image.number_of_instances - Machine.paused(@image.id).count).times do
      clave = (0...16).map { ('a'..'z').to_a[rand(26)] }.join
        machine = Machine.create(:image => @image, :remote_username => "openvdi", :remote_password=> clave )
        StartMachine.perform_async(machine.id)
      end
      redirect_to cloud_server_images_path, notice: 'Image was successfully created.' 
    else
      @machines = @cloud_server.machines
      @flavors = @cloud_server.flavors
      render action: 'new' 
    end
  end

  # PATCH/PUT /images/1
  def update
    @image.cloud_server = CloudServer.find(params[:cloud_server_id])
    if @image.update(image_params)
      authorize @image
        (@image.number_of_instances - Machine.paused(@image.id).count).times do
        clave = (0...16).map { ('a'..'z').to_a[rand(26)] }.join
        machine = Machine.create(:image => @image, :remote_username => "openvdi", :remote_password => clave )
        StartMachine.perform_async(machine.id)
      end
      redirect_to cloud_server_images_path, notice: 'Image was successfully updated.' 
    else
      @machines = @image.cloud_server.machines
      @flavors = @image.cloud_server.flavors
      render action: 'edit' 
    end
  end

  # DELETE /images/1
  def destroy
    authorize @image
    @cloud_server = CloudServer.find(params[:cloud_server_id])
    @image.machines.each do | machine |
      machine.cloud_destroy
      machine.destroy
    end
    @image.destroy
    redirect_to cloud_server_images_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:name, :description, :machine, :flavor, :number_of_instances, :cloud_server_id, {:role_ids => []}, :avatar)
    end
end
