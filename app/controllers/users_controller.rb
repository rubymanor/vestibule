class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_user

  def show
  end

  def edit
  end

  def update
    if current_user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user."
    end
    redirect_to user_path
  end

  private

  def load_user
    @user = current_user
  end
end