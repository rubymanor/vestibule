module AuthenticationSteps
  def sign_in(account = Factory(:account))
    visit "/accounts/sign_in"
    # hit wierd issue never had before where sub-context setups seem to be signed in from parent context
    # when writing reason_test.rb
    unless has_content?(account.email)
      fill_in "Email", :with => account.email
      fill_in "Password", :with => account.password
      click_button "Sign in"
    end
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