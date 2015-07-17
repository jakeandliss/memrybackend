Rails.application.routes.draw do

  devise_for :users
  # root 'welcome#index'
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  namespace 'api' do
    namespace 'v1', :constraints => {format: 'json'} do
      
      # User routes
      resources :users, :controller => "users", :only => [:create, :update, :show, :destroy] do
        collection do
          post :forgot_password
          post :change_password
          post :check_user
        end
      end

      # Entries routes
      resources :entries
    end
  end
end
