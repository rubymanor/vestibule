module ProposalSteps
  def propose_talk(options = {})
    options = options.reverse_merge(:title => 'A talk', :description => 'A great talk')

    visit proposals_path
    click_link "Propose talk"

    fill_in "Title", :with => options[:title]
    fill_in "Description", :with => options[:description]
    click_button "Create Proposal"
  end

  def within_proposal(&block)
    within(".proposal", &block)
  end

  def assert_page_has_proposal(options)
    within_proposal do
      assert page.has_content?(options[:title]) if options[:title]
      assert page.has_content?(options[:proposer]) if options[:proposer]
      assert page.has_content?(options[:description]) if options[:description]
    end
  end
end