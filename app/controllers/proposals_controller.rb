class ProposalsController < ApplicationController
  impressionist :actions=> [:show]

  respond_to :html
  respond_to :rss, :only => [:index, :show]

  def index
    authorize! :read, Proposal

    @withdrawn_proposals = Proposal.withdrawn.all
    @proposals = Proposal.active.order('created_at desc').all

    respond_with @proposals
  end

  def show
    @proposal = Proposal.find(params[:id])
    authorize! :read, @proposal

    @suggestion = Suggestion.new if can?(:create, Suggestion)

    respond_with @proposal
  end

  def new
    @proposal = Proposal.new({:proposer => current_user}.merge(params[:proposal] || {}))
    authorize! :new, @proposal
  end

  def create
    @proposal = Proposal.new({:proposer => current_user}.merge(params[:proposal] || {}))
    authorize! :create, @proposal

    if @proposal.save
      redirect_to proposals_path
    else
      render :new
    end
  end

  def edit
    @proposal = Proposal.find(params[:id])
    authorize! :edit, @proposal
  end

  def update
    @proposal = Proposal.find(params[:id])
    authorize! :update, @proposal

    if @proposal.update_attributes(params[:proposal])
      redirect_to proposal_path(@proposal)
    else
      render :edit
    end
  end

  def withdraw
    @proposal = Proposal.find(params[:id])
    authorize! :withdraw, @proposal

    @proposal.withdraw!
    redirect_to proposal_path(@proposal), alert: "Your proposal has been withdrawn"
  end

  def republish
    @proposal = Proposal.find(params[:id])
    authorize! :republish, @proposal

    @proposal.republish!
    redirect_to proposal_path(@proposal), notice: "Your proposal has been republished"
  end

  def vote
    @proposal = Proposal.find(params[:id])
    authorize! :vote, @proposal

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
