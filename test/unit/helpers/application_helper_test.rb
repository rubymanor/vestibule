require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  context "gravatar_url" do
    setup do
      @user = Factory(:user)
    end

    should "ask Gravatar.gravatar_url for a 50x50 image of the user using monsterid as the default" do
      Gravatar.expects(:gravatar_url).with(@user, has_entries(:default => 'monsterid', :size => 50))
      gravatar_url(@user)
    end

    should "return what Gravatar.gravatar_url returns" do
      Gravatar.stubs(:gravatar_url).returns(:whatever)
      assert_equal :whatever, gravatar_url(@user)
    end
  end
end
