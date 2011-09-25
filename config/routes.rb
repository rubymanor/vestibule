Vestibule::Application.routes.draw do
  resources :users, :only => [:show, :edit, :update]
  resource :agenda do
    member do
      post :add_item
    end
  end

  resources :proposals, :except => [:destroy] do
    resources :suggestions, :only => [:create]
    member do
      post :withdraw
    end
  end

  match "/motivation", :to => "home#motivation", :as => "motivation"
  match "/champs", :to => "home#champs", :as => "champs"
  match "/about", :to => "home#about", :as => "about"
  match "/my_motivation", :to => "home#my_motivation", :as => "complete_motivation"

  match "/dashboard", :to => "dashboard#index"

  match "/auth/twitter/callback", :to => "twitter_authentication#callback"
  match "/logout", :to => "twitter_authentication#logout", :as => "logout"

  root :to => "home#index"
end
