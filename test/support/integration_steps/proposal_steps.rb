module ProposalSteps
  def propose_talk(options = {})
    options = options.reverse_merge(:title => 'A talk')

    visit proposals_path
    click_link "Propose talk"

    fill_in "Title", :with => options[:title]
    click_button "Propose"
  end

  def assert_page_has_proposal(options)
    within(".proposal") do
      assert page.has_content?(options[:title])
      assert page.has_content?(options[:proposer]) if options[:proposer]
    end
  end
end