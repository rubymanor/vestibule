class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]
  before_filter :load_user
  before_filter :restrict_editing, :only => [:edit, :update]

  def show
  end

  def edit
  end

  def update
    redirect_to user_path(current_user), alert: 'This instance of vestibule is read only, you can\'t change your profile.'
    return
    if current_user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user."
    end
    redirect_to user_path(current_user)
  end

  private

  def load_user
    @user = User.find_by_twitter_nickname(params[:id])
  end

  def restrict_editing
    if @user != current_user
      flash[:alert] = "You cannot update another user"
      redirect_to user_path(current_user)
    end
  end
end