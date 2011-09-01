Vestibule::Application.routes.draw do
  resource :user, :only => [:edit, :update, :show]
  resources :proposals, :except => [:destroy] do
    resources :suggestions, :only => [:create]
  end

  match "/dashboard", :to => "dashboard#index"

  match "/auth/twitter/callback", :to => "twitter_authentication#callback"
  match "/logout", :to => "twitter_authentication#logout", :as => "logout"

  root :to => "home#index"
end
