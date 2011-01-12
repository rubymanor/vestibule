Vestibule::Application.routes.draw do
  devise_for :users

  resource :account, :only => [:edit, :update, :show]

  root :to => "accounts#show"
end
