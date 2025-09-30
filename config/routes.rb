Rails.application.routes.draw do
  resources :restaurants
  resources :menus_menu_items
  resources :menu_items
  resources :menus

  namespace :api do
    post "importation", to: "importation#import"
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
