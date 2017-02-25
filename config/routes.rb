Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations", sessions: "sessions" }

  get 'tags/:tag', to: 'articles#index', as: :tag
  resources :articles, only: [:index, :new, :create, :show]

  root 'articles#index'
end
