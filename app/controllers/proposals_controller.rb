class ProposalsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]

  impressionist :actions=> [:show]

  respond_to :html
  respond_to :rss, :only => [:index, :show]

  def index
    @withdrawn_proposals = Proposal.withdrawn.all
    respond_with @proposals = Proposal.active.order('created_at desc').all
  end

  def show
    @suggestion = Suggestion.new
    respond_with @proposal = Proposal.find(params[:id])
  end

  def new
    @proposal = Proposal.new
  end

  def create
    @proposal = current_user.proposals.new(params[:proposal])
    if @proposal.save
      redirect_to proposals_path
    else
      render :new
    end
  end

  before_filter :load_proposal_for_editing, :only => [:edit, :update]

  def edit
  end

  def update
    if @proposal.update_attributes(params[:proposal])
      redirect_to proposal_path(@proposal)
    else
      render :edit
    end
  end

  def withdraw
    proposal = current_user.proposals.find(params[:id])
    proposal.withdraw!
    redirect_to proposal_path(proposal), alert: "Your proposal has been withdrawn"
  end

  def republish
    proposal = current_user.proposals.find(params[:id])
    proposal.republish!
    redirect_to proposal_path(proposal), notice: "Your proposal has been republished"
  end

  def vote
    @proposal = Proposal.find(params[:id])

    if @proposal.proposed_by?(current_user)
      redirect_to proposal_path(@proposal), :flash => {:alert => "You can't vote for your own proposal!"}
    else
      if params[:vote] == 'clear'
        current_user.unvote_for(@proposal)
        flash[:notice] = 'Your vote has been cleared. Remember to come back to vote again once you are sure!'
      else
        current_user.vote(@proposal, :direction => params[:vote], :exclusive => true )
        flash[:notice] = 'Thank you for casting your vote. Your vote has been captured!'
      end

      redirect_to proposal_path(@proposal)
    end
  end

  private

  def load_proposal_for_editing
    @proposal = current_user.proposals.find_by_id(params[:id])
    if @proposal.nil?
      flash[:alert] = "You cannot edit proposals that are owned by other users"
      redirect_to :action => :show
    end
  end
end
