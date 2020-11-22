# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/login',    to: 'sessions#create'
  post '/logout',   to: 'sessions#destroy'
  get '/logged_in', to: 'sessions#check_logged_in?'

  resources :vaccination_programs

  resources :users, only: %i[create show index] do
    resources :items, only: %i[create show index destroy]
  end
end
