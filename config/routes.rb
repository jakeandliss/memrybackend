Rails.application.routes.draw do

  # root 'welcome#index'

  namespace 'api' do
    namespace 'v1', :constraints => {format: 'json'} do
      resources :users, :controller => "users", :only => [:create, :update, :show, :destroy] do
        collection do
          post :forgot_password
          post :change_password
        end
      end
    end
  end
end
