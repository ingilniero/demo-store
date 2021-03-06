class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_admin, :admin_logged?

protected
  def already_in_session!
    redirect_to backend_root_path if admin_logged?
  end

  def authenticate!
    redirect_to backend_sign_in_path unless admin_logged?
  end

  def admin_logged?
    !current_admin.nil?
  end

  def current_admin
    @current_admin ||= Admin.find_by_id session[:admin_id]
    @current_admin
  end
end
