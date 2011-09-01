require "test_helper"

class UserTest < ActiveSupport::TestCase
  context "An account" do
    setup do
      @user = Factory(:user)
    end

    should "be valid" do
      assert @user.valid?
    end
  end

end