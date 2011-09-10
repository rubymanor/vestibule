require 'test_helper'

class ProfileTest < IntegrationTestCase
  context "When viewing a user's profile when not logged in" do
    setup do
      @user = Factory(:user)
      @proposal = Factory(:proposal, :title => 'Pythonizing Ruby: Getting a ruby parser with syntactical whitespace', :proposer => @user)
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
  end

  context 'When logged in' do
    setup do
      @user = Factory(:user)
      sign_in @user
    end

    context 'and viewing a different user profile' do
      setup do
        @other_user = Factory(:user)
        @proposal = Factory(:proposal, :title => 'Pythonizing Ruby: Getting a ruby parser with syntactical whitespace', :proposer => @other_user)
        visit user_path(@other_user)
      end

      context "and they don't have a signup reason" do
        setup do
          @other_user.signup_reason = nil
          @other_user.save
          visit user_path(@other_user)
        end

        should 'not be invited to edit their reason' do
          assert !page.has_css?("a[href$='#{edit_user_path(@other_user)}']")
        end

        should 'not be invited to edit my reason' do
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
          assert page.has_content? @other_user.signup_reason
        end
      end

      should 'not be prompted to edit their reason' do
        within('#signup_reason') do
          assert !page.has_css?("a[href$='#{edit_user_path(@other_user)}']")
        end
      end

      should 'put the user name into the heading text' do
        assert page.has_css? 'h1', :text => "#{@other_user.name}'s account"
        assert page.has_css? 'h2', :text => "#{@other_user.name}'s proposals"
      end
    end

    context "and viewing my own user profile" do
      setup do
        @proposal = Factory(:proposal, :title => 'Pythonizing Ruby: Getting a ruby parser with syntactical whitespace', :proposer => @user)
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
      end
    end
  end
end
