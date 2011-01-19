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

  def i_am_asked_to_sign_in
    assert_equal new_account_session_path, current_path
    within ".alert" do
      assert page.has_content?("You need to sign in or sign up before continuing.")
    end
  end

  def i_am_warned_about(klass, attribute, message)
    id = [klass.name.underscore, attribute].join("_")
    within "\##{id} + span.error" do
      assert page.has_content?(message)
    end
  end
end
