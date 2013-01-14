require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  context "avatar_url" do
    context "for a user without a cached Twitter image" do
      setup do
        @user = FactoryGirl.create(:user, :github_nickname => "lazyatom")
      end

      should "construct a URL using tweetimag.es" do
        assert_equal "http://img.tweetimag.es/i/lazyatom_n", avatar_url(@user)
      end
    end

    context "for a user with a cached Twitter image" do
      setup do
        @user = FactoryGirl.create(:user, :github_nickname => "lazyatom", :github_image => "https://si0.twimg.com/profile_images/16060902/872836486_m_normal.jpg")
      end

      should "use the cached Twitter image" do
        assert_equal "https://si0.twimg.com/profile_images/16060902/872836486_m_normal.jpg", avatar_url(@user)
      end
    end
  end
end
