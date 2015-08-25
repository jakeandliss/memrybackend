module Api
  module V1
    class SessionsController < Devise::SessionsController

      prepend_before_filter :require_no_authentication, only: [:new, :create]
      skip_before_filter :verify_authenticity_token

      include Devise::Controllers::Helpers

      respond_to :json
     
      def create
        validate_json('userLoginForm', params.require(:userLoginForm))
        render json: { message: @errors }, status: :unprocessable_entity if @errors.present?
        super
        auth_token = new_authentication_token
        REDIS.set auth_token, resource.id 
      end

      def destroy
        user = warden.user
        user.revoke_token(user_auth_token) 
        super
      end

      def after_sign_in_path_for(resource)
        #session[:token] = resource.add_authentication_token if mobile_browser?
        stored_location_for(resource)
      end


      private

      def new_authentication_token
        loop do
          token = SecureRandom.base64.tr('+/=', 'Qrt')
          break token unless REDIS.get(token)
        end
      end


      def validate_json(schema, data)
        schema_directory = Rails.root.join('doc', 'api_docs', 'schemas')
        schema_path      = schema_directory.join("#{schema}.json").to_s
        @errors          ||= JSON::Validator.fully_validate(schema_path, data, :errors_as_objects => true)
      end
    end
  end
end
