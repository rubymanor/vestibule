require "test_helper"

class AccountTest < ActiveSupport::TestCase
  context "An account" do
    setup do
      @account = Factory(:account, :user => Factory(:user))
    end

    should "be valid" do
      assert @account.valid?
    end

    should belong_to(:user)
    should validate_presence_of(:user_id)
  end

end