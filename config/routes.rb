Vestibule::Application.routes.draw do
  devise_for :accounts

  resource :user, :only => [:edit, :update, :show]
  resources :proposals, :only => [:new, :create, :show, :index]

  root :to => "users#show"
end
