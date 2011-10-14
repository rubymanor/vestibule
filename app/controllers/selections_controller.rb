class SelectionsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]

  def index
    popular_proposals = Selection.popular[0..9]
    @top_proposals, @next_proposals = popular_proposals.each_with_index.partition {|p, i| i <= 7}.map {|s| s.map{|p,_| p}}
    if current_user
      @proposals = Proposal.available_for_selection_by(current_user)
    end
  end

  def create
    selection = current_user.selections.build(params[:selection])
    if selection.save
      redirect_to selections_path
    else
      redirect_to selections_path, alert: selection.errors.full_messages.to_sentence
    end
  end

  def destroy
    selection = current_user.selections.find(params[:id])
    selection.destroy
    redirect_to selections_path
  end
end