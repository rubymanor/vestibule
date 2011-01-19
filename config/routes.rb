Vestibule::Application.routes.draw do
  devise_for :accounts

  resource :user, :only => [:edit, :update, :show]

  root :to => "users#show"
end
