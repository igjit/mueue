Rails.application.routes.draw do
  namespace :player do
    resource :state, only: [:show, :update]
  end
end
