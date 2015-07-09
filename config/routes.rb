Rails.application.routes.draw do

  # root 'welcome#index'
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  namespace 'api' do
    namespace 'v1', :constraints => {format: 'json'} do
      resources :users, :controller => "users", :only => [:create, :update, :show, :destroy] do
        collection do
          post :forgot_password
          post :change_password
          post :check_user
          get  :tags, :to => "tags#user_tags"
        end
      end
      resources :tags, :controller => "tags", :only => [:create, :update, :destroy]
    end
  end
end
