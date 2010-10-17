class AccountsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_account

  def show
  end

  def edit
  end

  def update
    if @account.update_attributes(params[:account])
      flash[:notice] = "Succesfully updated account."
    end
    redirect_to @account
  end

  protected
  def load_account
    @account = current_user.account
  end

end