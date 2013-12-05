Vestibule::Application.routes.draw do
  resources :users, :only => [:show, :edit, :update]
  resources :proposals, :except => [:destroy] do
    resources :suggestions, :only => [:create]
    member do
      post :withdraw
    end
  end
  resources :selections, :only => [:index, :create, :destroy]

  if_feature :motivation do
    match "/motivation", :to => "home#motivation", :as => "motivation"
    match "/my-motivation", :to => "home#my_motivation", :as => "complete_motivation"
  end
  match "/about", :to => "home#about", :as => "about"
  match "/anonymous-proposals", :to => "home#anonymous_proposals", :as => "anonymous_proposals"
  match "/the-vestibule-process", :to => "home#the_vestibule_process", :as => "the_vestibule_process"

  match "/dashboard", :to => "dashboard#index"

  match "/auth/github/callback", :to => "github_authentication#callback"
  match "/logout", :to => "github_authentication#logout", :as => "logout"

  root :to => "home#index"
end
