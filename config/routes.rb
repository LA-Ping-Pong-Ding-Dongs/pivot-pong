PivotPong::Application.routes.draw do
  resources :matches, only: [:create, :index]
  resources :players, only: [:index, :show, :edit, :update], param: :key
  resources :players_search, only: :index
  resource :tournament, only: :show, controller: :tournament

  root 'dashboard#show'
end
