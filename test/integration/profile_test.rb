require 'test_helper'

class ProfileTest < IntegrationTestCase
  context "When viewing a user's profile" do
    setup do
      @user = Factory(:user)
      @proposal = Factory(:proposal, :title => 'Pythonizing Ruby: Getting a ruby parser with syntactical whitespace', :proposer => @user)
      visit user_path(@user)
    end

    should 'see a list of their proposals' do
      within('#proposals') do
        asset_page_has_link_to_proposal(@proposal)
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

  context "When viewing my own user profile" do
    setup do
      @user = Factory(:user)
      @proposal = Factory(:proposal, :title => 'Pythonizing Ruby: Getting a ruby parser with syntactical whitespace', :proposer => @user)
      sign_in @user
      visit user_path(@user)
    end

    should 'see a list of my proposals' do
      within('#proposals') do
        asset_page_has_link_to_proposal(@proposal)
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