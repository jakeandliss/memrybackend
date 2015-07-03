Rails.application.routes.draw do

  root 'welcome#index'

  namespace :api do
    namespace :v1 do
      devise_for :user,
             :path => "/",
             :path_names => {:sign_in => 'login', :registrations => 'register'},
      			 :stateless_token => true,
      			 controllers: { 
                  	registrations: "api/v1/registrations",
                    sessions: 'api/v1/login',
                  }
      resource 'users'
      resources :sessions
    end
  end


end
