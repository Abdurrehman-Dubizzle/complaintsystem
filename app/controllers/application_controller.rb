class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # kind of redundant because admin only hidden anyways in the views
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to dashboard_path, alert: "You are not authorized to access this page."
  end


  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:designation, :report_to_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:designation, :report_to_id])
  end

end
