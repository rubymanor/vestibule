class SuggestionsController < ApplicationController
  def create
    @proposal = Proposal.find(params[:proposal_id])
    authorize! :read, @proposal

    @suggestion = Suggestion.new(params[:suggestion].merge(:proposal => @proposal, :author => current_user))
    authorize! :create, @suggestion

    if @suggestion.save
      redirect_to proposal_path(@proposal), notice: "Your suggestion has been published"
    else
      render :template => 'proposals/show'
    end
  end
end