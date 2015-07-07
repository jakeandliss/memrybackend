Rails.application.routes.draw do

  # root 'welcome#index'

  namespace 'api' do
    namespace 'v1', :constraints => {format: 'json'} do
      resources :users, :controller => "users", :only => [:update, :show, :destroy] do
        collection do
          post :forgot_password
          post :change_password
        end
      end

      # resources :forgot_password, :to => "users#forgot_password", :only => [:create]
      # resources :change_password, :to => "users#change_password", :only => [:show, :update]
    end

  end

end
