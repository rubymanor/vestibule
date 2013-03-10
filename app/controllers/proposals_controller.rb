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

  private

  def load_proposal_for_editing
    @proposal = current_user.proposals.find_by_id(params[:id])
    if @proposal.nil?
      flash[:alert] = "You cannot edit proposals that are owned by other users"
      redirect_to :action => :show
    end
  end
end
