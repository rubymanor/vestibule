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
    @proposal = current_account.proposals.create!(params[:proposal])
    redirect_to proposals_path
  end
end
