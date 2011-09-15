require 'test_helper'

class ProfileTest < IntegrationTestCase
  setup do
    @user = Factory(:user, :name => "Dave Smith")
    @proposal = Factory(:proposal, :title => 'Pythonizing Ruby: Getting a ruby parser with syntactical whitespace', :proposer => @user)
    @involved_proposal = Factory(:proposal, :title => 'All about rubygems: what the hell is going on?')
    Factory(:suggestion, :body => 'Can you talk about the alternatives to rubygems? Maybe even RAA, even though I know it is a blast from the past.', :author => @user, :proposal => @involved_proposal)
    @uninvolved_proposal = Factory(:proposal, :title => 'JSON and the gem-o-nauts')
    @especially_involved_proposal = Factory(:proposal, :title => 'What price modularity: a discussion on include & extend')
    Factory(:suggestion, :body => 'I do not want this to be all about rails, but will this cover ActiveSupport::Concern?', :author => @user, :proposal => @especially_involved_proposal)
    Factory(:suggestion, :body => 'Thanks for the update! This all sounds great; just what I want the guys on my team to hear!', :author => @user, :proposal => @especially_involved_proposal)
    Factory(:suggestion, :body => 'I\'m definitely having second thoughts about this proposal.', :author => @user, :proposal => @proposal)
  end

  context "When viewing a user's profile when not logged in" do
    setup do
      visit user_path(@user)
    end

    context "and they don't have a signup reason" do
      setup do
        @user.signup_reason = nil
        @user.save
        visit user_path(@user)
      end

      should 'not be invited to edit their reason' do
        assert !page.has_css?("a[href$='#{edit_user_path(@user)}']")
      end
    end

    should 'see a list of their proposals' do
      within('#proposals') do
        assert_page_has_link_to_proposal(@proposal)
      end
    end

    should 'see their reason for signing up' do
      within('#signup_reason') do
        assert page.has_content? @user.signup_reason
      end
    end

    should 'not be prompted to edit their reason' do
      within('#signup_reason') do
        assert !page.has_css?("a[href$='#{edit_user_path(@user)}']")
      end
    end

    should 'put the user name into the heading text' do
      assert page.has_css? 'h1', :text => "#{@user.name}'s account"
      assert page.has_css? 'h2', :text => "#{@user.name}'s proposals"
    end

    should 'see a list of other users\' proposals, but only ones that the user is involved with via their suggestions' do
      within('#involvement') do
        assert_page_has_link_to_proposal(@involved_proposal)
        assert_page_has_link_to_proposal(@especially_involved_proposal)
        assert_page_has_no_link_to_proposal(@uninvolved_proposal)
        assert_page_has_no_link_to_proposal(@proposal)
      end
    end

    should 'not see proposals more than once if the user has made multiple suggestions' do
      within('#involvement') do
        assert page.has_css?("a[href='#{proposal_path(@especially_involved_proposal)}']", :count => 1)
      end
    end
  end

  context 'When logged in' do
    context 'and viewing a different user profile' do
      setup do
        @me = Factory(:user)
        sign_in @me
        visit user_path(@user)
      end

      context "and they don't have a signup reason" do
        setup do
          @user.signup_reason = nil
          @user.save
          visit user_path(@user)
        end

        should 'not be invited to edit their reason' do
          assert !page.has_css?("a[href$='#{edit_user_path(@user)}']")
        end

        should 'not be invited to edit my reason' do
          assert !page.has_css?("a[href$='#{edit_user_path(@me)}']")
        end
      end

      should 'see a list of their proposals' do
        within('#proposals') do
          assert_page_has_link_to_proposal(@proposal)
        end
      end

      should 'see their reason for signing up' do
        within('#signup_reason') do
          assert page.has_content? @user.signup_reason
        end
      end

      should 'not be prompted to edit their reason' do
        within('#signup_reason') do
          assert !page.has_css?("a[href$='#{edit_user_path(@user)}']")
        end
      end

      should 'put the user name into the heading text' do
        assert page.has_css? 'h1', :text => "#{@user.name}'s account"
        assert page.has_css? 'h2', :text => "#{@user.name}'s proposals"
        assert page.has_css? 'h2', :text => "Other proposals #{@user.name} is involved with"
      end

      should 'see a list of other users\' proposals, but only ones that the user is involved with via their suggestions' do
        within('#involvement') do
          assert_page_has_link_to_proposal(@involved_proposal)
          assert_page_has_link_to_proposal(@especially_involved_proposal)
          assert_page_has_no_link_to_proposal(@uninvolved_proposal)
          assert_page_has_no_link_to_proposal(@proposal)
        end
      end

      should 'not see proposals more than once if the user has made multiple suggestions' do
        within('#involvement') do
          assert page.has_css?("a[href='#{proposal_path(@especially_involved_proposal)}']", :count => 1)
        end
      end
    end

    context "and viewing my own user profile" do
      setup do
        sign_in @user
        visit user_path(@user)
      end

      should 'see a list of my proposals' do
        within('#proposals') do
          assert_page_has_link_to_proposal(@proposal)
        end
      end

      should 'see my reason for signing up' do
        within('#signup_reason') do
          assert page.has_content? @user.signup_reason
        end
      end

      should 'be prompted to edit their reason' do
        within('#signup_reason') do
          assert page.has_css?("a[href$='#{edit_user_path(@user)}']")
        end
      end

      should 'refer to the user as "you" in the heading text' do
        assert page.has_css? 'h1', :text => "Your account"
        assert page.has_css? 'h2', :text => "Your proposals"
        assert page.has_css? 'h2', :text => "Other proposals you are involved with"
      end

      should 'see a list of other users\' proposals, but only ones that I am involved with via their suggestions' do
        within('#involvement') do
          assert_page_has_link_to_proposal(@involved_proposal)
          assert_page_has_link_to_proposal(@especially_involved_proposal)
          assert_page_has_no_link_to_proposal(@uninvolved_proposal)
          assert_page_has_no_link_to_proposal(@proposal)
        end
      end

      should 'not see proposals more than once if I have made multiple suggestions' do
        within('#involvement') do
          assert page.has_css?("a[href='#{proposal_path(@especially_involved_proposal)}']", :count => 1)
        end
      end
    end
  end
end
