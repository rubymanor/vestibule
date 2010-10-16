Vestibule::Application.routes.draw do
  resources :talks, :only => [:index, :show]

  root :to => "talks#index"
end
