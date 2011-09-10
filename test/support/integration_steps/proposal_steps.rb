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
      if options[:proposer]
        i_can_see_the_avatar_for_user options[:proposer]
        assert page.has_css?("a[href='#{user_path(options[:proposer])}']", :text => options[:proposer].name)
      end
      assert page.has_content?(options[:description]) if options[:description]
    end
  end

  def asset_page_has_link_to_proposal(proposal)
    assert page.has_css?("a[href$='#{proposal_path(proposal)}']", :text => proposal.title)
  end

  def assert_page_has_suggestion(options)
    within(".suggestions") do
      if options[:author]
        i_can_see_the_avatar_for_user options[:author]
        assert page.has_css?("a[href='#{user_path(options[:author])}']", :text => options[:author].name)
      end
      assert page.has_content? options[:body]
    end
  end
end