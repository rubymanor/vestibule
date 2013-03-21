class DashboardController < ApplicationController
  def index
    authorize! :see, :dashboard

    @your_proposals = current_user.proposals
    @proposals_you_should_look_at = current_user.proposals_you_should_look_at
    @proposals_that_have_changed = current_user.proposals_that_have_changed
    @proposals_that_have_been_withdrawn = current_user.proposals_that_have_been_withdrawn
  end
end