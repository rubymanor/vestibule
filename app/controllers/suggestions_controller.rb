class SuggestionsController < ApplicationController
  before_filter :authenticate_user!

  def create
    redirect_to proposal_path(@proposal), alert: 'This instance of vestibule is read only, you can\'t make suggestions to improve proposals.'
    return
    @proposal = Proposal.find(params[:proposal_id])
    @suggestion = current_user.suggestions.build(params[:suggestion].merge(:proposal => @proposal))
    if @suggestion.save
      redirect_to proposal_path(@proposal)
    else
      render :template => 'proposals/show'
    end
  end
end