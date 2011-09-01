require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  context "avatar_url" do
    setup do
      @user = Factory(:user, :twitter_nickname => "lazyatom")
    end

    should "construct a URL using twitterimag.es" do
      assert_equal "http://img.tweetimag.es/i/lazyatom_n", avatar_url(@user)
    end
  end
end
