module AuthenticationSteps
  def sign_in(user)
    OmniAuth.config.mock_auth[:github] = {
      "provider" => "github",
      "uid" => user.github_uid,
      "info" => {"name" => user.name, "nickname" => user.github_nickname, "image" => user.github_image}
    }
    visit "/auth/github"
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
