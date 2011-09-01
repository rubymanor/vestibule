class HomeController < ApplicationController
  def index
    flash[:notice] = flash[:notice]
    if user_signed_in?
      redirect_to dashboard_path
    else
      redirect_to proposals_path
    end
  end
end