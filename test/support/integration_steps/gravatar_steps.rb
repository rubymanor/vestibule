module GravatarSteps
  def i_can_see_the_gravatar_for_user(user)
    expected_img_src = Gravatar.gravatar_url(user, :size => 50, :default => 'monsterid')
    assert has_css?(".avatar img.gravatar[src='#{expected_img_src}']")
  end
end