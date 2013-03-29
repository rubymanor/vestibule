Vestibule::Application.routes.draw do
  resources :users, :only => [:show, :edit, :update]
  resources :proposals, :except => [:destroy] do
    resources :suggestions, :only => [:create]
    member do
      post :withdraw
      post :republish
      post :vote
    end
  end

  match "/motivation", :to => "home#motivation", :as => "motivation"
  match "/about", :to => "home#about", :as => "about"
  match "/my-motivation", :to => "home#my_motivation", :as => "complete_motivation"

  match "/dashboard", :to => "dashboard#index"

  match "/auth/:provider/callback", :to => "authentication#callback"
  match "/logout", :to => "authentication#logout", :as => "logout"

  root :to => "home#index"
end
