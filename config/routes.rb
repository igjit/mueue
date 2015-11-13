Rails.application.routes.draw do
  resources :youtube_playlists, only: [:index, :new, :create, :destroy]

  namespace :player do
    resource :state, only: [:show, :update]
  end
end
