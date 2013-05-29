Pong::Application.routes.draw do
  resource :top_ten, only: [:show]

  resources :matches do
    collection do
      get 'rankings'
      get 'players'
    end
  end

  resources :doubles_matches do
    collection do
      get 'rankings'
    end
  end

  root to: 'top_ten#show'
end
