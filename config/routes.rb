Vestibule::Application.routes.draw do
  resources :talks, :only => [:index, :show, :new, :create]

  root :to => "talks#index"
end
