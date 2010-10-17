Vestibule::Application.routes.draw do
  devise_for :users

  resource :account, :only => [:edit, :update, :show]

  resources :talks, :except => [:destroy] do
    resources :feedbacks, :only => [:create]
  end

  root :to => "talks#index"
end
