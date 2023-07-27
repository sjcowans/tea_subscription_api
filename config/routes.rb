Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get "/customers/:id/teas/:id/subscribe", to: "customers#subscribe"
  get "/customers/:id/teas/:id/unsubscribe", to: "customers#unsubscribe"
  get "/customers/:id/teas", to: "teas#index"
end
