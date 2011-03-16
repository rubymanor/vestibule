require "test_helper"

class AccountAuthenticationTest < IntegrationTestCase

  context "A user signing up with valid attributes" do
    setup do
      visit "/"
      click_link "Sign up"
      fill_in "Email", :with => "john@example.com"
      fill_in "Password", :with => "letmein"
      fill_in "Password confirmation", :with => "letmein"
      click_button "Sign up"
    end

    should "send an email to the user to confirm address" do
      assert_equal 1, ActionMailer::Base.deliveries.count
      sent_email = ActionMailer::Base.deliveries.first
      assert_equal ["john@example.com"], sent_email.to

      assert page.has_content?("You have been sent a confirmation email. Please follow the link sent to continue.")
    end

    context "When following the link sent in the email" do
      setup do
        sent_email = ActionMailer::Base.deliveries.first
        links = URI.extract(sent_email.body.to_s, ["http", "https"])
        visit links.first
      end

      should "confirm the account and sign in user" do
        assert page.has_content?("Your account was successfully confirmed. You are now signed in.")
        assert page.has_css?("header nav", :text => "john@example.com")
      end
    end
  end

  context "A registered user signing in with valid attributes" do
    setup do
      @account = Factory(:account)
      visit "/"
      click_link "Sign in"
      fill_in "Email", :with => @account.email
      fill_in "Password", :with => @account.password
      click_button "Sign in"
    end

    should "sign in and tell the user" do
      assert has_content?("Signed in successfully.")
      assert has_css?("header nav", :text => @account.email)
    end

    should "show the user a 50x50 version of their gravatar in the main user area" do
      within('header nav') do
        i_can_see_the_gravatar_for_account(@account)
      end
    end
  end

  context "When signed in" do
    setup do
      sign_in
    end

    should "be able to sign out" do
      visit "/"
      click_link "Sign out"
      assert page.has_css?("header nav", :text => "Sign in")
    end
  end

  context "A user signing up with invalid attributes" do
    setup do
      visit "/"
      click_link "Sign up"
      fill_in "Email", :with => ""
      fill_in "Password", :with => ""
      fill_in "Password confirmation", :with => ""
      click_button "Sign up"
    end

    should "not send a confirmation email" do
      assert_equal 0, ActionMailer::Base.deliveries.count
    end

    should "tell the user what needs to be corrected" do
      assert has_content?("2 errors prohibited this account from being saved")
      assert has_content?("Email can't be blank")
      assert has_content?("Password can't be blank")
    end
  end

end