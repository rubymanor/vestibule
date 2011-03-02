Vestibule::Application.routes.draw do
  devise_for :accounts

  resource :user, :only => [:edit, :update, :show]
  resources :proposals, :except => [:destroy] do
    resources :suggestions, :only => [:create]
  end

  match "/dashboard", :to => "dashboard#index"

  root :to => "home#index"
end
