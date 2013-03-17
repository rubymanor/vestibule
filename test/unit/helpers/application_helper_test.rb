require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "avatar_url constructs an image using gravatar" do
    user = FactoryGirl.build(:user, :email => "alice@example.com")
    assert_equal "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email)}?d=retro", avatar_url(user)
  end

  test "avatar_url constructs a 0 image using gravatar when no email is present" do
    user = FactoryGirl.build(:user, :email => nil)
    assert_equal "http://www.gravatar.com/avatar/00000000000000000000000000000000?d=retro", avatar_url(user)
  end

  test "authentication links in p" do
    expected_markup = <<HTML
<p><a href="/auth/google">Google</a></p>
<p><a href="/auth/twitter">Twitter</a></p>
<p><a href="/auth/github">Github</a></p>
<p><a href="/auth/facebook">Facebook</a></p>
HTML
    actual_markup = authentication_links(:p)

    assert_equal expected_markup.strip, actual_markup.strip
    assert actual_markup.html_safe?
  end

  test "authentication links in li" do
    expected_markup = <<HTML
<li><a href="/auth/google">Google</a></li>
<li><a href="/auth/twitter">Twitter</a></li>
<li><a href="/auth/github">Github</a></li>
<li><a href="/auth/facebook">Facebook</a></li>
HTML
    actual_markup = authentication_links(:li)

    assert_equal expected_markup.strip, actual_markup.strip
    assert actual_markup.html_safe?
  end
end
