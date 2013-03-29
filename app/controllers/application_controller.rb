class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization

  helper_method :current_user, :user_signed_in?

  before_filter :reload_settings if Rails.env.development?

  rescue_from CanCan::AccessDenied do |exception|
    if user_signed_in?
      flash[:alert] = exception.message
      redirect_to(request.referer.presence || root_url)
    else
      authenticate_user!
    end
  end

  private

  def reload_settings
    Settings.reload!
  end

  def authenticate_user!
    unless current_user
      flash[:alert] = "You need to sign in or sign up before continuing."
      session[:user_id] = nil
      redirect_to(request.referer.presence || root_url)
    end
  end

  def user_signed_in?
    current_user.present?
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end
end
