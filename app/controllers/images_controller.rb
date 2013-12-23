class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy ]

  # GET /images
  def index
    @cloud_server = CloudServer.find(params[:cloud_server_id])   
    @images = @cloud_server.images
  end

  # GET /images/new
  def new
    @cloud_server = CloudServer.find(params[:cloud_server_id])
    @machines = @cloud_server.machines
    @flavors = @cloud_server.flavors
    @image = Image.new
    @image.cloud_server = @cloud_server
  end

  # GET /images/1/edit
  def edit
    @cloud_server = CloudServer.find(params[:cloud_server_id])
  end

  # POST /images
  def create
    @cloud_server = CloudServer.find(params[:cloud_server_id])
    @image = Image.new(image_params)
    @image.cloud_server = CloudServer.find(params[:cloud_server_id])
    if @image.save
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
      redirect_to cloud_server_images_path, notice: 'Image was successfully updated.' 
    else
      render action: 'edit' 
    end
  end

  # DELETE /images/1
  def destroy
    @cloud_server = CloudServer.find(params[:cloud_server_id])
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
      params.require(:image).permit(:name, :description, :machine, :flavor, :number_of_instances, :cloud_server_id)
    end
end
