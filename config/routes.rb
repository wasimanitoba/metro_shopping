# == Route Map
#

Rails.application.routes.draw do
  resources :packages
  resources :purchases do
    member do
      get 'deals'
    end
  end
  resources :stores
  resources :items do
    collection do
      post 'upload'
    end
  end
  post 'bulk_create', to: 'purchases#bulk_create'
  get 'spreadsheet', to: 'purchases#spreadsheet'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get 'deals', to: 'items#deals'
  get 'summary', to: 'items#summary'
  get 'shopping_list', to: "items#shopping"
  get 'checkout_preview', to: "packages#checkout"
  post 'checkout', to: "packages#checkout", as: :checkout
  # Defines the root path route ("/")
  root "home#index"
end
