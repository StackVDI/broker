class CloudServersController < ApplicationController
  before_action :set_cloud_server, only: [:show, :edit, :update, :destroy]

  # GET /cloud_servers
  def index
    @cloud_servers = CloudServer.all
  end

  # GET /cloud_servers/1
  def show
  end

  # GET /cloud_servers/new
  def new
    @cloud_server = CloudServer.new
  end

  # GET /cloud_servers/1/edit
  def edit
  end

  # POST /cloud_servers
  def create
    @cloud_server = CloudServer.new(cloud_server_params)
    if @cloud_server.save
      redirect_to cloud_servers_path, notice: 'Cloud server was successfully created.' 
    else
      render action: 'new' 
    end
  end

  # PATCH/PUT /cloud_servers/1
  def update
    if @cloud_server.update(cloud_server_params)
      redirect_to cloud_servers_path, notice: 'Cloud server was successfully updated.' 
    else
      render action: 'edit'
    end
  end

  # DELETE /cloud_servers/1
  # DELETE /cloud_servers/1.json
  def destroy
    @cloud_server.destroy
    redirect_to cloud_servers_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cloud_server
      @cloud_server = CloudServer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cloud_server_params
      params.require(:cloud_server).permit(:name, :description, :username, :password, :url)
    end
end
