class Api::V1::LoginController < Devise::SessionsController

  # Require our abstraction for encoding/deconding JWT.
  require 'auth_token'

  # Disable CSRF protection
  skip_before_action :verify_authenticity_token

  # Be sure to enable JSON.
  respond_to :json

  def create
    self.resource = warden.authenticate!(auth_options)
    # set_flash_message(:notice, :signed_in) if is_flashing_format?
    # sign_in(resource_name, resource)
    # yield resource if block_given?

    token = AuthToken.issue_token({user_id: resource.id})
    respond_with resource, location: after_sign_in_path_for(resource) do |format|
      format.json { render json: {user: resource.email, token: token} }
    end

  end

end
