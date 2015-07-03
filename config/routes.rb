Rails.application.routes.draw do

  # root 'welcome#index'

  namespace 'api' do
    namespace 'v1', :constraints => {format: 'json'} do
      resources :registrations, :controller => "users", :only=> [:create]
    end

  end

end
