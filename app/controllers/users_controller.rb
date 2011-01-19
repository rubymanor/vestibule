class UsersController < ApplicationController
  before_filter :authenticate_account!
  before_filter :load_user

  def show
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user."
    end
    redirect_to user_path
  end

  protected
  def load_user
    @user = current_account.user
  end

end