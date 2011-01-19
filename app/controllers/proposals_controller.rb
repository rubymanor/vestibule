class ProposalsController < ApplicationController
  before_filter :authenticate_account!, :except => [:index, :show]

  def index
    @proposals = Proposal.all
  end

  def show
    @proposal = Proposal.find(params[:id])
  end

  def new
    @proposal = Proposal.new
  end

  def create
    @proposal = current_account.proposals.new(params[:proposal])
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

  private

  def load_proposal_for_editing
    @proposal = current_account.proposals.find_by_id(params[:id])
    if @proposal.nil?
      flash[:alert] = "You cannot edit proposals that are owned by other users"
      redirect_to :action => :show
    end
  end
end
