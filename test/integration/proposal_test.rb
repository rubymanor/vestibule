require "test_helper"

class ProposalTest < IntegrationTestCase

  context "As a visitor to the site" do
    should "not see a link to propose a talk" do
      visit proposals_path
      assert !page.has_content?("Propose talk"), "link to propose talk should not be present!"
    end

    should "not be able to propose a talk" do
      visit new_proposal_path
      i_am_asked_to_sign_in
    end

    context "given a proposal already exists" do
      setup do
        @proposal = Factory(:proposal, :title => "Ruby Muby Schmuby")
      end

      should "be able to see the list of proposals" do
        visit proposals_path
        assert page.has_css?('ul.proposals')
      end

      should "be able to subscribe to the rss feed of proposals" do
        visit proposals_path
        assert page.has_css?("link[rel='alternate'][type='application/rss+xml'][href$='#{proposals_path(:format => :rss)}']")
        visit proposals_path(:format => :rss)
        assert_match %r{application/rss\+xml}, page.response_headers['Content-Type']
        assert page.has_xpath?('.//item/title', :text => %{"#{@proposal.title}" by #{@proposal.proposer.name} (@#{@proposal.proposer.twitter_nickname})})
      end

      should "be able to read individual proposals" do
        visit proposals_path
        click_link "Ruby Muby Schmuby"
        assert_page_has_proposal :title => "Ruby Muby Schmuby"
      end

      should "not see a link to edit a proposal" do
        visit proposals_path
        click_link "Ruby Muby Schmuby"
        assert !page.has_content?("Edit proposal"), "link to edit proposal should not be present"
      end

      should "not be able to edit a proposal" do
        visit edit_proposal_path(@proposal)
        i_am_asked_to_sign_in
      end
    end
  end

  context "Given I am logged in" do
    setup do
      @user = Factory(:user)
      sign_in @user
    end

    context "and I have not added a proposal to my agenda" do
      setup { @proposal = Factory(:proposal, :title => "Add me to agenda") }

      should "see a button for adding it to my agenda" do
        visit proposals_path
        click_link "Add me to agenda"
        assert page.has_css?("input#add_to_agenda")
      end
    end

    context "and I propose a talk with all the required details" do
      setup { propose_talk :title => "My Amazing Talk", :description => 'This talk is amazing.' }

      should "be able to see my proposal on the site" do
        visit proposals_path
        click_link "My Amazing Talk"
        assert_page_has_proposal \
          :title        => "My Amazing Talk",
          :description  => 'This talk is amazing.',
          :proposer     => @user
      end

      should "be able to withdraw my proposal" do
        visit proposals_path
        click_link "My Amazing Talk"
        click_button "Withdraw proposal"

        assert_proposal_withdrawn "My Amazing Talk"
      end

      context "and then edit my proposal" do
        setup do
          visit proposals_path
          click_link "My Amazing Talk"
          click_link "Edit proposal"
        end

        context "with valid content" do
          setup do
            fill_in "Title", :with => "My Even More Amazing Talk"
            fill_in "Description", :with => "This talk is wildly amazing."
            click_button "Update Proposal"
          end

          should "update the proposal" do
            visit proposals_path
            click_link "My Even More Amazing Talk"
            assert_page_has_proposal \
              :title        => "My Even More Amazing Talk",
              :description  => 'This talk is wildly amazing.',
              :proposer     => @user
          end
        end

        context "and remove the title" do
          setup do
            fill_in "Title", :with => ""
            click_button "Update Proposal"
          end

          should "alert me that the title is required" do
            i_am_warned_about Proposal, :title, "can't be blank"
          end
        end
      end
    end

    context "and I propose a talk with markdown-formatted description" do
      setup do
        propose_talk :title => "My Amazing Talk", :description => %{
# A moment in time

blah blah blah
        }.strip
      end

      should "be able to see my proposal with a formatted description" do
        visit proposals_path
        click_link "My Amazing Talk"
        within_proposal do
          within(".description") do
            assert page.has_css?('h1', :text => 'A moment in time')
            assert page.has_css?('p', :text => 'blah blah blah')
          end
        end
      end
    end

    context "and I propose a talk without a title" do
      setup { propose_talk :title => nil }

      should "alert me that the title is required" do
        i_am_warned_about Proposal, :title, "can't be blank"
      end
    end

    context "and a proposal from another user exists" do
      setup do
        @other_persons_proposal = Factory(:proposal, :title => "Another talk")
      end

      should "not see a link to edit that proposal" do
        visit proposals_path
        click_link "Another talk"
        assert !page.has_content?("Edit proposal"), "link to edit proposal should not be present"
      end

      should "not be able to edit that proposal" do
        visit edit_proposal_path(@other_persons_proposal)
        i_am_alerted "You cannot edit proposals that are owned by other users"
      end
    end

    context "and there are some proposals (mine and others)" do
      setup do
        propose_talk :title => "My Amazing Talk", :description => %{
# A moment in time

blah blah blah
        }.strip
        @other_persons_proposal = Factory(:proposal, :title => "Another talk", :created_at => 3.days.ago)
      end

      should "be able to subscribe to the rss feed of proposals" do
        visit proposals_path
        assert page.has_css?("link[rel='alternate'][type='application/rss+xml'][href$='#{proposals_path(:format => :rss)}']")
        visit proposals_path(:format => :rss)
        assert_match %r{application/rss\+xml}, page.response_headers['Content-Type']
      end

      should 'have my talk and the other talk in the feed, in newest first order' do
        visit proposals_path(:format => :rss)
        assert page.has_xpath?('.//item[position() = 2]/title', :text => %{"#{@other_persons_proposal.title}" by #{@other_persons_proposal.proposer.name} (@#{@other_persons_proposal.proposer.twitter_nickname})})
        assert page.has_xpath?('.//item[position() = 1]/title', :text => %{"My Amazing Talk" by #{@user.name} (@#{@user.twitter_nickname})})
      end
    end
  end
end
