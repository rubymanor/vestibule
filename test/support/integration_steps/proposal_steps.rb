module ProposalSteps
  def propose_talk(options = {})
    options = options.reverse_merge(:title => 'A talk', :description => 'A great talk')

    visit proposals_path
    click_link "Propose a talk"

    fill_in "Title", :with => options[:title]
    fill_in "Description", :with => options[:description]
    click_button "Submit proposal"
  end

  def within_proposal(&block)
    within(".proposal", &block)
  end

  def assert_page_has_proposal(options)
    assert page.has_css?("title", :text => "#{options[:title]} - #{Settings.event_name}") if options[:title]
    within_proposal do
      assert page.has_content?(options[:title]) if options[:title]
      if options[:proposer]
        refute page.has_css?("a[href='#{user_path(options[:proposer])}']", :text => options[:proposer].name)
      end
      assert page.has_content?(options[:description]) if options[:description]
    end
  end

  def assert_page_has_link_to_proposal(proposal)
    assert page.has_css?("a[href$='#{proposal_path(proposal)}']", :text => proposal.title)
  end

  def assert_page_has_no_link_to_proposal(proposal)
    assert !page.has_css?("a[href$='#{proposal_path(proposal)}']", :text => proposal.title)
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

  def assert_proposal_withdrawn(name)
    assert page.has_css?(".proposal.withdrawn")
  end

  def assert_proposal_republished
    assert page.has_no_css?(".proposal.withdrawn")
  end

end
