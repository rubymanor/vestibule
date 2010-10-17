Vestibule::Application.routes.draw do
  devise_for :users

  resource :account, :only => [:edit, :update, :show]

  resources :talks, :except => [:destroy]

  root :to => "talks#index"
end
