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
end
