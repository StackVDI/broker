class WelcomeController < ApplicationController
  def index
    @available_images = current_user.images_available
    @running_machines = current_user.machines
    @max_concurrent_machines = current_user.max_concurrent_machines
  end
end
