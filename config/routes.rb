Rails.application.routes.draw do

  root 'welcome#index'

  namespace :api, constraints: {format: 'json'} do
    namespace :v1 do
      devise_for :users, :stateless_token => true, controllers: {
                           registrations: "api/v1/registrations",
                           sessions: 'api/v1/login'
                       }
    end
  end


end
