module AvatarSteps
  def i_can_see_the_avatar_for_user(user)
    expected_img_src = "http://img.tweetimag.es/i/#{user.twitter_nickname}_n"
    assert has_css?("img.avatar[src='#{expected_img_src}']")
  end
end