Rails.application.routes.draw do

  # root 'welcome#index'

  namespace 'api' do
    namespace 'v1', :constraints => {format: 'json'} do
      resources :users, :controller => "users", :only => [:create, :update, :show, :destroy] do
        collection  do
          post 'check_user', :to => "users#check_user_exists"
        end
      end
      resources :forgot_password, :to => "users#forgot_password", :only => [:create]
      resources :change_password, :to => "users#change_password", :only => [:show, :update]
      # resources :check_user, :to => "users#check_user_exists", :only => [:create]
    end
  end

end
