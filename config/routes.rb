PivotPong::Application.routes.draw do
  resources :matches, only: [:create, :index]
  resources :players, only: :show, param: :key
  resource :tournament, only: :show, controller: :tournament

  root 'dashboard#show'
end
