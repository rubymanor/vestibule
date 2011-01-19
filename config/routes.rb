Vestibule::Application.routes.draw do
  devise_for :accounts

  resource :user, :only => [:edit, :update, :show]
  resources :talks, :only => [:new, :create, :show, :index]

  root :to => "users#show"
end
