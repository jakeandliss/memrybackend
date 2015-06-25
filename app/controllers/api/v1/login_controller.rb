class Api::V1::LoginController < Devise::SessionsController

  # Require our abstraction for encoding/deconding JWT.
  require 'auth_token'

  # Disable CSRF protection
  skip_before_action :verify_authenticity_token

  # Be sure to enable JSON.
  respond_to :json

  def create
    resource = User.find_for_database_authentication(:email => params[:email])
    if resource.nil?
      render :json=> {:success => "ERROR", :message => "User not found"}, :status=>401
    else
      if resource.valid_password?(params[:password])
        token = AuthToken.issue_token({user_id: resource.id})
        render :json=> {:success => "SUCCESS", :token => token, :user => {
            :email => resource.email,
            :first_name => resource.first_name,
            :last_name => resource.last_name
          }   
        }
      else
        render :json=> {:success => "ERROR", :error => "Password doesn't match."}, :status=>401
      end
    end
  end

end
