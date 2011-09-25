Vestibule::Application.routes.draw do
  resources :users, :only => [:show, :edit, :update]
  resources :proposals, :except => [:destroy] do
    resources :suggestions, :only => [:create]
    member do
      post :withdraw
    end
  end

  match "/motivation", :to => "home#motivation", :as => "motivation"
  match "/champs", :to => "home#champs", :as => "champs"
  match "/about", :to => "home#about", :as => "about"
  match "/my_motivation", :to => "home#my_motivation"

  match "/dashboard", :to => "dashboard#index"

  match "/auth/twitter/callback", :to => "twitter_authentication#callback"
  match "/logout", :to => "twitter_authentication#logout", :as => "logout"

  root :to => "home#index"
end
