Rails.application.routes.draw do

  root 'welcome#index'

  # devise_for :users

  namespace :api, constraints: {format: 'json'} do
    namespace :v1 do
      resources :user
    end
  end


end
