class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :user_signed_in?, :can?

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
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  def can?(action, object)
    Vestibule.mode_of_operation.can?(action, object)
  end
end
