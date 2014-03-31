CookieStore::Application.routes.draw do
  resources :cookie_orders

  resources :cookies

  resources :substances
  resources :recipes
  resources :pallets
  resources :customers
  resources :orders

  get "/pallet_search", to: 'pallets#search'

  post "/block_pallets", to: 'pallets#block'
  post "/produce_pallets", to: 'pallets#produce'

  root 'pallets#index'
end
