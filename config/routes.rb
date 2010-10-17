Vestibule::Application.routes.draw do
  resources :talks, :except => [:destroy]

  root :to => "talks#index"
end
