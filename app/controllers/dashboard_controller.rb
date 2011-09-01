class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    @your_proposals = current_user.proposals
    @proposals_you_should_look_at = current_user.proposals_you_should_look_at
    @proposals_that_have_changed = current_user.proposals_that_have_changed
  end
end