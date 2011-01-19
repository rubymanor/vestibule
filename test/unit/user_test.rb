require "test_helper"

class UserTest < ActiveSupport::TestCase
  context "An account" do
    setup do
      @user = Factory(:user, :account => Factory(:account))
    end

    should "be valid" do
      assert @user.valid?
    end

    should belong_to(:account)
    should validate_presence_of(:account_id)
  end

end