module SimpleSteps
  def i_am_on(expected_path)
    assert_equal expected_path, current_path
  end

  def the_page_has_title(expected_title)
    ['h1', 'title'].each do |title_selector|
      within(title_selector) do
        assert page.has_content?(expected_title), %Q{Expected "#{expected_title}" within CSS selector '#{title_selector}', but it's not there}
      end
    end
  end

  def i_am_not_authorized
    within ".alert" do
      assert page.has_content?("You are not authorized to access this page.")
    end
  end

  def i_am_asked_to_sign_in
    within ".alert" do
      assert page.has_content?("You need to sign in or sign up before continuing.")
    end
  end

  def i_am_warned_about(klass, attribute, message)
    id = [klass.name.underscore, attribute].join("_")
    within ".error \##{id} ~ .help-inline" do
      assert page.has_content?(message)
    end
  end

  def i_am_alerted(message)
    within ".alert" do
      assert page.has_content?(message)
    end
  end
end
