class HomeController < ApplicationController
  def index
    authorize! :see, :index
    flash.keep
    if user_signed_in?
      redirect_to dashboard_path
    else
      redirect_to proposals_path
    end
  end

  def motivation
    authorize! :see, :motivation
    @users = User.with_signup_reasons.shuffle
    @slackers = User.without_signup_reasons.shuffle
  end

  def my_motivation
    authorize! :see, :my_motivation
    redirect_to edit_user_path(current_user)
  end
end
