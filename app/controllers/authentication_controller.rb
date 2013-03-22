class AuthenticationController < ApplicationController

  def callback
    authorize! :create, :session

    auth_hash = request.env['omniauth.auth']

    user = User.find_or_create_with_omniauth(auth_hash)
    session[:user_id] = user.id
    user.update_provider_details(auth_hash)

    redirect_to root_url, :notice => "Signed in successfully."
  end

  def logout
    authorize! :destroy, :session

    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
end
