module AuthenticationSteps
  def sign_in
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