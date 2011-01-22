class DashboardController < ApplicationController
  before_filter :authenticate_account!

  def index
    @your_proposals = current_account.proposals
    @proposals_you_should_look_at = current_account.proposals_you_should_look_at
    @proposals_that_have_changed = current_account.proposals_that_have_changed
  end
end