class SuggestionsController < ApplicationController
  before_filter :authenticate_account!

  def create
    @proposal = Proposal.find(params[:proposal_id])
    @suggestion = current_account.suggestions.build(params[:suggestion].merge(:proposal => @proposal))
    if @suggestion.save
      redirect_to proposal_path(@proposal)
    else
      render :template => 'proposals/show'
    end
  end
end