class AgendasController < ApplicationController
  before_filter :authenticate_user!, :ensure_agenda

  def add_item
    proposal = Proposal.find(params[:proposal_id])
    current_user.agenda.agenda_items << AgendaItem.create(:user => current_user, :proposal => proposal)
    redirect_to :back
  end

  private

  def ensure_agenda
    unless current_user.agenda
      current_user.agenda = Agenda.create
    end
  end
end
