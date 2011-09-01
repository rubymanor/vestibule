require "test_helper"

class UserTest < ActiveSupport::TestCase
  context "A user" do
    setup do
      @user = Factory(:user)
    end

    should "be valid" do
      assert @user.valid?
    end

    context "who has made suggestions on a proposal" do
      setup do
        @proposal = Factory(:proposal)
        Factory(:suggestion, :proposal => @proposal, :author => @user)
      end

      should "have that proposal in their proposals of interest" do
        assert_equal [@proposal], @user.proposals_of_interest
      end
    end
  end

end