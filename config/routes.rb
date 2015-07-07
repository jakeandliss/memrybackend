Rails.application.routes.draw do

  # root 'welcome#index'

  namespace 'api' do
    namespace 'v1', :constraints => {format: 'json'} do
      resources :users, :controller => "users", :only => [:create, :update]
    end
  end
end
