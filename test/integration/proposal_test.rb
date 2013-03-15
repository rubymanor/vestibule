
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
        @proposal = FactoryGirl.create(:proposal, :title => "Ruby Muby Schmuby")
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
        assert page.has_xpath?('.//item/title', :text => @proposal.title)
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
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    context 'and the app is in "cfp" mode' do
      setup { Vestibule.mode_of_operation = :cfp }

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
              click_button "Update proposal"
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
              click_button "Update proposal"
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
          @other_persons_proposal = FactoryGirl.create(:proposal, :title => "Another talk")
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
          @other_persons_proposal = FactoryGirl.create(:proposal, :title => "Another talk", :created_at => 3.days.ago)
        end

        should "be able to subscribe to the rss feed of proposals" do
          visit proposals_path
          assert page.has_css?("link[rel='alternate'][type='application/rss+xml'][href$='#{proposals_path(:format => :rss)}']")
          visit proposals_path(:format => :rss)
          assert_match %r{application/rss\+xml}, page.response_headers['Content-Type']
        end

        should 'have my talk and the other talk in the feed, in newest first order' do
          visit proposals_path(:format => :rss)
          assert page.has_xpath?('.//item[position() = 2]/title', :text => @other_persons_proposal.title)
          assert page.has_xpath?('.//item[position() = 1]/title', :text => "My Amazing Talk")
        end
      end
    end

    context 'and the app is in "review mode"' do
      setup { Vestibule.mode_of_operation = :review }

      should "not see a link to propose a talk" do
        visit proposals_path
        assert !page.has_content?("Propose talk"), "link to propose talk should not be present!"
      end

      should "not be able to propose a talk" do
        visit new_proposal_path
        i_am_alerted("In review mode you cannot make a proposal")
      end

      context 'and I have a proposal of my own' do
        setup { FactoryGirl.create(:proposal, title: 'My Amazing Talk', proposer: @user) }

        should "be able to withdraw my proposal" do
          visit proposals_path
          click_link "My Amazing Talk"
          click_button "Withdraw proposal"

          assert_proposal_withdrawn "My Amazing Talk"
        end

        should "be able to edit my proposal" do
          visit proposals_path
          click_link "My Amazing Talk"
          click_link "Edit proposal"
          fill_in "Title", :with => "My Even More Amazing Talk"
          fill_in "Description", :with => "This talk is wildly amazing."
          click_button "Update proposal"
          visit proposals_path
          click_link "My Even More Amazing Talk"
          assert_page_has_proposal \
            :title        => "My Even More Amazing Talk",
            :description  => 'This talk is wildly amazing.',
            :proposer     => @user
        end
      end
    end

    context 'and the app is in "voting mode"' do
      setup { Vestibule.mode_of_operation = :voting }

      should "not see a link to propose a talk" do
        visit proposals_path
        assert !page.has_content?("Propose talk"), "link to propose talk should not be present!"
      end

      should "not be able to propose a talk" do
        visit new_proposal_path
        i_am_alerted("In voting mode you cannot make a proposal")
      end

      context 'and I have a proposal of my own' do
        setup { FactoryGirl.create(:proposal, title: 'My Amazing Talk', proposer: @user) }

        should "be able to withdraw my proposal" do
          visit proposals_path
          click_link "My Amazing Talk"
          click_button "Withdraw proposal"

          assert_proposal_withdrawn "My Amazing Talk"
        end

        should "be able to edit my proposal" do
          visit proposals_path
          click_link "My Amazing Talk"
          click_link "Edit proposal"
          fill_in "Title", :with => "My Even More Amazing Talk"
          fill_in "Description", :with => "This talk is wildly amazing."
          click_button "Update proposal"
          visit proposals_path
          click_link "My Even More Amazing Talk"
          assert_page_has_proposal \
            :title        => "My Even More Amazing Talk",
            :description  => 'This talk is wildly amazing.',
            :proposer     => @user
        end
      end
    end

    context 'and the app is in "agenda mode"' do
      setup { Vestibule.mode_of_operation = :agenda }

      should "not see a link to propose a talk" do
        visit proposals_path
        assert !page.has_content?("Propose talk"), "link to propose talk should not be present!"
      end

      should "not be able to propose a talk" do
        visit new_proposal_path
        i_am_alerted("In agenda mode you cannot make a proposal")
      end

      should 'see the author details for a talk that has been confirmed' do
        p = FactoryGirl.create(:proposal)
        visit proposal_path(p)
        within '.proposal' do
          refute page.has_content?(p.proposer.name)
        end
        p.confirm!
        visit proposal_path(p)
        within '.proposal' do
          assert page.has_content?(p.proposer.name)
        end
      end

      context 'and I have a proposal of my own' do
        setup { FactoryGirl.create(:proposal, title: 'My Amazing Talk', proposer: @user) }

        should "be able to withdraw my proposal" do
          visit proposals_path
          click_link "My Amazing Talk"
          click_button "Withdraw proposal"

          assert_proposal_withdrawn "My Amazing Talk"
        end

        should "be able to edit my proposal" do
          visit proposals_path
          click_link "My Amazing Talk"
          click_link "Edit proposal"
          fill_in "Title", :with => "My Even More Amazing Talk"
          fill_in "Description", :with => "This talk is wildly amazing."
          click_button "Update proposal"
          visit proposals_path
          click_link "My Even More Amazing Talk"
          assert_page_has_proposal \
            :title        => "My Even More Amazing Talk",
            :description  => 'This talk is wildly amazing.',
            :proposer     => @user
        end
      end
    end

    context 'and the app is in "archive mode"' do
      setup { Vestibule.mode_of_operation = :archive }

      should "not see a link to propose a talk" do
        visit proposals_path
        assert !page.has_content?("Propose talk"), "link to propose talk should not be present!"
      end

      should "not be able to propose a talk" do
        visit new_proposal_path
        i_am_alerted("In archive mode you cannot make a proposal")
      end

      context 'and I have a proposal of my own' do
        setup { FactoryGirl.create(:proposal, title: 'My Amazing Talk', proposer: @user) }

        should "not see a link to withdraw my proposal" do
          visit proposals_path
          click_link "My Amazing Talk"
          assert !page.has_content?("Withdraw proposal")
        end

        should "not see a link to edit my proposal" do
          visit proposals_path
          click_link "My Amazing Talk"
          assert !page.has_content?("Edit proposal"), "link to edit proposal should not be present"
        end

        should "not be able to edit my proposal" do
          visit edit_proposal_path(Proposal.find_by_title('My Amazing Talk'))
          i_am_alerted "In archive mode you cannot change a proposal"
        end
      end
    end
  end
end
