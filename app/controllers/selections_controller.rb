class SelectionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @proposals = Proposal.available_for_selection_by(current_user)
  end

  def create
    selection = current_user.selections.build(params[:selection])
    if selection.save
      redirect_to user_selections_path(current_user)
    else
      redirect_to user_selections_path(current_user), alert: selection.errors.full_messages.to_sentence
    end
  end

  def destroy
    selection = current_user.selections.find(params[:id])
    selection.destroy
    redirect_to user_selections_path(current_user)
  end
end