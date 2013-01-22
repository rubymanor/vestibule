class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :user_signed_in?

  private

  def authenticate_user!
    unless current_user
      flash[:alert] = "You need to sign in or sign up before continuing."
      session[:user_id] = nil
      redirect_to root_url
    end
  end

  def user_signed_in?
    current_user.present?
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
