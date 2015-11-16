Rails.application.routes.draw do
  root 'top#index'

  resources :youtube_playlists, only: [:index, :new, :create, :destroy]

  get '/player', to: 'player#show'
  namespace :player do
    resource :state, only: [:show, :update]
  end
end
