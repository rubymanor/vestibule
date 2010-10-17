Vestibule::Application.routes.draw do
  devise_for :users

  resources :talks, :except => [:destroy]

  root :to => "talks#index"
end
