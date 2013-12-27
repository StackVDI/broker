class WelcomeController < ApplicationController
  def index
    @available_images = current_user.images_available
  end
end
