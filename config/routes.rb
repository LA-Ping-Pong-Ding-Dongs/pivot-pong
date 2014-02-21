PivotPong::Application.routes.draw do
  resources :matches, only: :create

  root 'dashboard#show'
end
