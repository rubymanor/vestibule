require "test_helper"

class UserTest < ActiveSupport::TestCase
  context "A user" do
    setup do
      @user = Factory(:user, :signup_reason => nil)
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
        assert_equal [@proposal], @user.reload.proposals_of_interest
      end

      should_change("their contribution_score", :from => 0, :to => 2) { @user.contribution_score }
    end

    context "who makes a proposal" do
      setup do
        @proposal = Factory(:proposal, :proposer => @user)
      end

      should_change("their contribution_score", :from => 0, :to => 10) { @user.contribution_score }

      context "that is then suggested upon" do
        setup do
          Factory(:suggestion, :proposal => @proposal)
        end

        should_change("their contribution_score", :from => 10, :to => 15) { @user.reload.contribution_score }
      end
    end
  end

end