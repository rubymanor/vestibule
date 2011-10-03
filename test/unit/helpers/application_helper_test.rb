require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  context "avatar_url" do
    context "for a user without a cached Twitter image" do
      setup do
        @user = Factory(:user, :twitter_nickname => "lazyatom")
      end

      should "construct a URL using twitterimag.es" do
        assert_equal "http://img.tweetimag.es/i/lazyatom_n", avatar_url(@user)
      end
    end

    context "for a user with a cached Twitter image" do
      setup do
        @user = Factory(:user, :twitter_nickname => "lazyatom", :twitter_image => "https://si0.twimg.com/profile_images/16060902/872836486_m_normal.jpg")
      end

      should "use the cached Twitter image" do
        assert_equal "https://si0.twimg.com/profile_images/16060902/872836486_m_normal.jpg", avatar_url(@user)
      end
    end
  end

	context "wiki" do
	  context "for a single user" do
	    setup do
	      @user = Factory(:user, :twitter_nickname => "rdrake98", :name => "Richard Drake")
	    end

	    should "turn into link" do
	      assert_equal link_to("Richard Drake", "/users/rdrake98"), wikiize("[[Richard Drake]]")
	    end
	  end
	
	  context "for a single proposal" do
	    setup do
	      @user = Factory(:proposal, :title => "My One and Only")
	    end

	    should "turn into link" do
	      assert_equal link_to("My One and Only", "/proposals/1"), wikiize("[[My One and Only]]")
	      assert_equal link_to("Her Latest Idea", "/proposals/new?title=Her%2520Latest%2520Idea"), wikiize("[[Her Latest Idea]]")
	      assert_equal(
					"I prefer <a href=\"/proposals/new?title=Her%2520Latest%2520Idea\">Her Latest Idea</a> to <a href=\"/proposals/1\">My One and Only</a>.", 
					wikiize("I prefer [[Her Latest Idea]] to [[My One and Only]].")
				)
	    end
	  end
	end
end
