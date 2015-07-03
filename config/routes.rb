Rails.application.routes.draw do

  # root 'welcome#index'

  namespace 'api' do
    namespace 'v1', :constraints => {format: 'json'} do
      resources :registrations, :controller => "users", :only => [:create]
      resources :users, :controller => "users", :only => [:update]
    end

  end

end
