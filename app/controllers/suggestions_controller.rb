class SuggestionsController < ApplicationController
  def create
    proposal = Proposal.find(params[:proposal_id])
    proposal.suggestions.create!(params[:suggestion].merge(:author => current_account.user))
    redirect_to proposal_path(proposal)
  end
end