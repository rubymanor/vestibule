module AuthenticationSteps
  def sign_in(user)
    OmniAuth.config.mock_auth[:twitter] = {
      "provider" => "twitter",
      "uid" => user.twitter_uid,
      "user_info" => {"name" => user.name, "nickname" => user.twitter_nickname, "image" => user.twitter_image}
    }
    visit "/auth/twitter"
  end

  def there_are_sign_up_and_sign_in_links
    assert page.has_link?('sign up')
    assert page.has_link?('sign in')
  end

  def there_are_no_sign_up_and_sign_in_links
    assert page.has_no_link?('sign up')
    assert page.has_no_link?('sign in')
  end
end