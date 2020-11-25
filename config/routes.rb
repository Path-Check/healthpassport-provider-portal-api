# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/login',    to: 'sessions#create'
  post '/logout',   to: 'sessions#destroy'
  get '/logged_in', to: 'sessions#check_logged_in?'
  get '/u/:id/pub_key', to: 'users#pub_key'

  resources :vaccination_programs do
    member do
      match 'verify', 'certify', via: %i[get post]
    end
  end

  resources :users, only: %i[create show] do
    resources :items, only: %i[create show destroy]
    member do
      match 'pub_key', via: %i[get post]
    end
  end
end
