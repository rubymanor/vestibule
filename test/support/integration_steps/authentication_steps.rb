module AuthenticationSteps
  def sign_in(user = Factory(:user))
    visit "/users/sign_in"
    # hit wierd issue never had before where sub-context setups seem to be signed in from parent context
    # when writing reason_test.rb
    unless has_content?(user.email)
      fill_in "Email", :with => user.email
      fill_in "Password", :with => user.password
      click_button "Sign in"
    end
  end

  def there_are_signup_or_login_links
    assert page.has_link?('sign up')
    assert page.has_link?('sign in')
  end

  def there_are_no_signup_or_login_links
    assert page.has_no_link?('sign up')
    assert page.has_no_link?('sign in')
  end
end