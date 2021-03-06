class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user

  private
  def current_user
    @current_user ||= User.find_by_session_token(session[:session_token])
  end

  def login!(user)
    session[:session_token] = user.session_token
  end

  def log_out
    current_user.try(:reset_session_token!)
    session[:session_token] = nil
  end

  def require_sign_in
    redirect_to new_session_url unless current_user
  end

end
