require "sidekiq/web"

Rails.application.routes.draw do
scope "(:locale)", locale: /en|kor/ do
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}
  root 'static_pages#home'
  get  '/security',   to: 'securities#index'
  get  '/show_security',    to: 'securities#show'
  post '/create_order', to: 'orders#create'
  get  '/faq',         to: 'static_pages#faq'
  get  '/show_price',         to: 'securities#show'
  get  '/show_price',         to: 'securities#show'
  get  '/leader_board',         to: 'leader_board#index'
end
  mount Sidekiq::Web => '/sidekiq'
end
