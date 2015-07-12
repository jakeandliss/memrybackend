module Api
  module V1
    class SessionsController < Devise::SessionsController

      skip_before_filter :verify_authenticity_token

      include Devise::Controllers::Helpers

      respond_to :json

      def create
        super
      end

      def destroy
        user = warden.user
        user.revoke_token(user_auth_token) if mobile_browser?
        super
      end

      def after_sign_in_path_for(resource)
        session[:token] = resource.add_authentication_token if mobile_browser?
        stored_location_for(resource)
      end
    end
  end
end