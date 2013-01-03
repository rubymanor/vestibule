require "test_helper"

class UserTest < ActiveSupport::TestCase
  context "A user" do
    setup do
      @user = FactoryGirl.create(:user, :signup_reason => nil)
    end

    should "be valid" do
      assert @user.valid?
    end

    context "who has made suggestions on a proposal" do
      setup do
        @proposal = FactoryGirl.create(:proposal)
        @old_score = @user.contribution_score
        FactoryGirl.create(:suggestion, :proposal => @proposal, :author => @user)
      end

      should "have that proposal in their proposals of interest" do
        assert_equal [@proposal], @user.reload.proposals_of_interest
      end

      should 'change their contribution_score' do
        assert_equal 0, @old_score
        assert_equal 2, @user.contribution_score
      end
    end

    context "who makes a proposal" do
      should 'change their contribution_score' do
        assert_equal 0, @user.reload.contribution_score
        FactoryGirl.create(:proposal, :proposer => @user)
        assert_equal 10, @user.reload.contribution_score
      end

      context "that is then suggested upon" do
        setup do
          @proposal = FactoryGirl.create(:proposal, :proposer => @user)
        end
        should 'change their contribution_score' do
          assert_equal 10, @user.reload.contribution_score
          FactoryGirl.create(:suggestion, :proposal => @proposal)
          assert_equal 15, @user.reload.contribution_score
        end
      end
    end
  end

end