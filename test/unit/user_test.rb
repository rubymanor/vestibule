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

    context 'who wants to signs up' do
      context 'with github' do
        setup do
          @user = User.create_with_omniauth(:info => {:name => 'User name',
                                                      :nickname => 'Nickname',
                                                      :email => 'email@example.com'},
                                            :provider => 'github',
                                            :uid => 'uid')
        end

        should 'should have the name set' do
          assert_equal 'User name', @user.name
        end

        should 'should have the email set' do
          assert_equal 'email@example.com', @user.email
        end

        should 'should have the github uid set' do
          assert_equal 'uid', @user.github_uid
        end

        should 'should have the github nickname set' do
          assert_equal 'Nickname', @user.github_nickname
        end
      end

      context 'with facebook' do
        setup do
          @user = User.create_with_omniauth(:info => {:name => 'User name',
                                                      :nickname => 'Nickname',
                                                      :email => 'email@example.com'},
                                            :provider => 'facebook',
                                            :uid => 'uid')
        end

        should 'should have the name set' do
          assert_equal 'User name', @user.name
        end

        should 'should have the email set' do
          assert_equal 'email@example.com', @user.email
        end

        should 'should have the facebook uid set' do
          assert_equal 'uid', @user.facebook_uid
        end

        should 'should have the facebook nickname set' do
          assert_equal 'Nickname', @user.facebook_nickname
        end
      end

      context 'with twitter' do
        setup do
          @user = User.create_with_omniauth(:info => {:name => 'User name',
                                                      :nickname => 'Nickname',
                                                      :email => 'email@example.com'},
                                            :provider => 'twitter',
                                            :uid => 'uid')
        end

        should 'should have the name set' do
          assert_equal 'User name', @user.name
        end

        should 'should have the email set' do
          assert_equal 'email@example.com', @user.email
        end

        should 'should have the twitter uid set' do
          assert_equal 'uid', @user.twitter_uid
        end

        should 'should have the twitter nickname set' do
          assert_equal 'Nickname', @user.twitter_nickname
        end
      end

      context 'with google' do
        setup do
          @user = User.create_with_omniauth(:info => {:name => 'User name',
                                                      :nickname => 'Nickname',
                                                      :email => 'email@example.com'},
                                            :provider => 'google',
                                            :uid => 'uid')
        end

        should 'should have the name set' do
          assert_equal 'User name', @user.name
        end

        should 'should have the email set' do
          assert_equal 'email@example.com', @user.email
        end

        should 'should have the google uid set' do
          assert_equal 'uid', @user.google_uid
        end

        should 'should have the google nickname set' do
          assert_equal 'Nickname', @user.google_nickname
        end
      end
    end
  end

end