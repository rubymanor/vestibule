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
				@long = link_to("Richard Drake", "/users/rdrake98")
				@short = link_to("@rdrake98", "/users/rdrake98")
	    end

	    should "not turn into link" do
	      assert_equal "[[]]", wikiize("[[]]")
				# what about multiple lines inside [[...]]?
	      assert_equal "@other", wikiize("@other")
	    end

	    should "turn into link" do
	      assert_equal @long, wikiize("[[Richard Drake]]")
	      assert_equal @short, wikiize("@rdrake98")
	      assert_equal "#{@long}same as #{@short}; #{@short} is but not @other.", wikiize("[[Richard Drake]]same as @rdrake98; @rdrake98 is but not @other.")
	      assert_equal "#{@long}not same as@rdrake98; #{@short} is.", wikiize("[[Richard Drake]]not same as@rdrake98; @rdrake98 is.")
				# the following ain't perfect but we can probably live with it
	      assert_equal "#{@long}same as #{@short};@rdrake98 isn't.", wikiize("[[Richard Drake]]same as @rdrake98;@rdrake98 isn't.")
	    end
	  end
	
	  context "for a single proposal" do
	    setup do
	      @user = Factory(:proposal, :title => "My One and Only")
				@my_only = link_to("My One and Only", "/proposals/1")
				@her_latest = link_to("Her Latest Idea", "/proposals/new?title=Her%2520Latest%2520Idea", :class => "New")
	    end

	    should "turn into link" do
	      assert_equal @my_only, wikiize("[[My One and Only]]")
	      assert_equal @her_latest, wikiize("[[Her Latest Idea]]")
	      assert_equal "I prefer #{@her_latest} to #{@my_only}.", wikiize("I prefer [[Her Latest Idea]] to [[My One and Only]].")
	    end
	  end
	end
end
