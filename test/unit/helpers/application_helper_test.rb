require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "avatar_url constructs an image using gravatar" do
    user = FactoryGirl.build(:user, :email => "alice@example.com")
    assert_equal "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email)}", avatar_url(user)
  end
end
