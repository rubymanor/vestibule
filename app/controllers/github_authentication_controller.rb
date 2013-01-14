class GithubAuthenticationController < ApplicationController
  def callback
    auth_hash = request.env['omniauth.auth']
    user = User.find_by_github_uid(auth_hash['uid']) || User.create_with_omniauth(auth_hash)

    session[:user_id] = user.id
    redirect_to root_url, :notice => "Signed in successfully."
  end

  def logout
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
end
