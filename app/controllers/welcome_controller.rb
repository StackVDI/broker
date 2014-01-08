class WelcomeController < ApplicationController
  def index
    @available_images = current_user.images_available
    @running_machines = current_user.machines
  end
end
