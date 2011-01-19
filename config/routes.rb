Vestibule::Application.routes.draw do
  devise_for :accounts

  resource :user, :only => [:edit, :update, :show]
  resources :proposals, :except => [:destroy] do
    resources :suggestions, :only => [:create]
  end

  root :to => "users#show"
end
