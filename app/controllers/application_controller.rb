class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  include Pundit
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :authenticate_user!

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password) }
    end
    
  private
    def user_not_authorized
      flash[:error] = "You are not allowed to perform this action."
      redirect_to request.headers["Referer"] || root_path
    end

end
