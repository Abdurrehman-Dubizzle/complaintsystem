# app/controllers/concerns/admin_authorization.rb
module AdminAuthorization
  extend ActiveSupport::Concern



  def authorize_admin!
    unless current_user&.admin?
      flash[:alert] = "Access denied. Admins only."
      redirect_to dashboard_path
    end
  end
end
