module AvatarSteps
  def i_can_see_the_avatar_for_user(user)
    expected_img_src = "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email)}?d=retro"
    assert has_css?("img.avatar[src='#{expected_img_src}']")
  end
end
