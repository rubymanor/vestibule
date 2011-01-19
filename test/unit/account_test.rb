require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  context "An account" do
    setup do
      @account = Factory(:account)
    end
    subject { @account }

    should "be valid" do
      assert @account.valid?
    end

    should "create a user" do
      assert @account.user.present?
    end

    should allow_value("bob@example.com").for(:email)
    should_not allow_value("bob").for(:email)
    should have_one(:user)
  end
end
