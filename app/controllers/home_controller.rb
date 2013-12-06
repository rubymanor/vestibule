class HomeController < ApplicationController
  def index
    flash.keep
    if user_signed_in?
      redirect_to dashboard_path
    else
      redirect_to proposals_path
    end
  end

  def motivation
    @users = User.with_signup_reasons.shuffle
    @losers = User.without_signup_reasons.shuffle
  end

  def my_motivation
    authenticate_user!
    redirect_to edit_user_path(current_user) if current_user.known?
  end

  def anonymous_proposals
  end
end
