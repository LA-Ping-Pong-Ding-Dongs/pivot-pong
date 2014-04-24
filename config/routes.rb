PivotPong::Application.routes.draw do
  apipie
  resources :matches, only: [:create, :index] do
    collection do
      get :recent
    end
  end
  resources :players, only: [:index, :show, :edit, :update], param: :key
  resources :players_search, only: :index
  resource :tournament, only: :show, controller: :tournament

  root 'dashboard#show'

  namespace :api do
    resources :players, only: :index
    resources :matches
  end
end
