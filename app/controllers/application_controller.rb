require 'feature_flag'
class ApplicationController < ActionController::Base
  include FeatureFlag
  protect_from_forgery
  helper_method :current_user, :user_signed_in?
  before_filter :set_archive_mode_warning_if_required

  private

  def authenticate_user!
    unless current_user.known?
      flash[:alert] = "You need to sign in or sign up before continuing."
      session[:user_id] = nil
      redirect_to root_url
    end
  end

  def user_signed_in?
    current_user.known?
  end

  def current_user
    @current_user ||= session[:user_id] ? User.find(session[:user_id]) : AnonymousUser.new
  end

  def set_archive_mode_warning_if_required
    if Vestibule.mode_of_operation.mode == :archive
      flash.now[:archive] = 'This version of Vestibule is <em>read only</em>. It represents an archive of the community effort to produce content for <a href="http://rubymanor.org/4/">Ruby Manor 4</a>.'.html_safe
    end
  end
end
