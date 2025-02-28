Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      # Autenticação
      post 'signup', to: 'users#create'
      post 'login', to: 'sessions#create'

      # Recursos
      resources :users, only: [:show, :update]
      resources :products, only: [:index, :show, :create, :update, :destroy]

      # Carrinho de Compras
      resource :cart, only: [:show] do
        resources :items, only: [:create, :update, :destroy], controller: 'cart_items'
      end

      # Pedidos
      resources :orders, only: [:index, :show, :create]

      # Pagamentos
      post 'payments', to: 'payments#create'
    end
  end
end