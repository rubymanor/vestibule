module GravatarSteps
  def i_can_see_the_gravatar_for_account(account)
    expected_img_src = Gravatar.gravatar_url(account, :size => 50, :default => 'monsterid')
    assert has_css?("img.gravatar[src='#{expected_img_src}']")
  end
end