TriageWeb::Application.routes.draw do

  resources :users, only: [:create]
  resources :sessions, only: [:create]
  resources :tasks, only: [:index, :create, :update, :destroy]

end
