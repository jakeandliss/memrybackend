Rails.application.routes.draw do

  devise_for :users, controllers: { sessions: "api/v1/sessions"}
  # root 'welcome#index'
#  require 'sidekiq/web'
#  mount Sidekiq::Web => '/sidekiq'

  namespace 'api' do
    namespace 'v1', :constraints => {format: 'json'} do

    # devise_scope :user do
    #    #resource :sessions, only: [:new, :create, :destroy]
    #
    #  end

      resources :users, :controller => "users", :only => [:create, :update, :show, :destroy] do
        collection do
          post :forgot_password
          post :change_password
          post :validate_email
          get  :tags, :to => "tags#user_tags"
        end
        resources :entries
      end
      resources :tags, :only => [:create, :update, :destroy, :index]
    end
  end

  match "*path", to: "errors#catch_404", via: :all
end
