Vestibule::Application.routes.draw do
  devise_for :accounts

  resource :user, :only => [:edit, :update, :show]
  resources :proposals, :except => [:destroy]

  root :to => "users#show"
end
