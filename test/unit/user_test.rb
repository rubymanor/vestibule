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

      should 'not change their contribution_score if the suggestion was on their own proposal' do
        @proposal.proposer = @user
        @proposal.save
        @user.update_contribution_score
        assert_equal 0, @user.contribution_score
      end
    end

    context "who makes a proposal" do
      should 'not change their contribution_score (because, anonymous)' do
        assert_equal 0, @user.reload.contribution_score
        FactoryGirl.create(:proposal, :proposer => @user)
        assert_equal 0, @user.reload.contribution_score
      end

      context "that is then suggested upon" do
        setup do
          @proposal = FactoryGirl.create(:proposal, :proposer => @user)
        end
        should 'not change their contribution_score (because, anonymous)' do
          assert_equal 0, @user.reload.contribution_score
          FactoryGirl.create(:suggestion, :proposal => @proposal)
          assert_equal 0, @user.reload.contribution_score
        end
      end
    end

    context 'who provides their motivation' do
      setup do
        @user.signup_reason = nil
        @user.save
      end

      should 'change their contribution_score' do
        assert_equal 0, @user.reload.contribution_score
        @user.signup_reason = 'I want to hear about fun and interesting things that I\'m not exposed to in my day job'
        @user.save
        assert_equal 5, @user.reload.contribution_score
      end
    end

    should "not be thought anonymous" do
      refute @user.anonymous?
      assert @user.known?
    end
  end

end
