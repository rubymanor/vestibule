require 'test_helper'

class UserTest < ActiveSupport::TestCase
  context "A user" do
    setup do
      @user = Factory(:user)
    end
    subject { @user }

    should "be valid" do
      assert @user.valid?
    end

    should "create an account" do
      assert @user.account.present?
    end

    should allow_value("bob@example.com").for(:email)
    should_not allow_value("bob").for(:email)
    should have_one(:account)
  end
end
