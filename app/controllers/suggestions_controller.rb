class SuggestionsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @proposal = Proposal.find(params[:proposal_id])
    check_mode_of_operation
    @suggestion = current_user.suggestions.build(params[:suggestion].merge(:proposal => @proposal))
    if @suggestion.save
      redirect_to proposal_path(@proposal)
    else
      render :template => 'proposals/show'
    end
  end

  def check_mode_of_operation
    unless can?(:make, :suggestion)
      flash[:alert] = "In #{Vestibule.mode_of_operation.mode} mode you cannot make a suggestion."
      redirect_to proposal_path(@proposal)
    end
  end

end