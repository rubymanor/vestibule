module SelectionSteps
  def select_proposal(title)
    proposal = Proposal.find_by_title(title)
    within "#selection_proposal_#{proposal.id}" do
      click_button "Select"
    end
  end

  def deselect_proposal(title)
    proposal = Proposal.find_by_title(title)
    within "#selection_proposal_#{proposal.id}" do
      click_button "Deselect"
    end
  end
end