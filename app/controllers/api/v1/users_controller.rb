module Api
  module V1
    class UsersController  < ApplicationController
      skip_before_action :verify_authenticity_token, if: :json_request?
      skip_before_filter :verify_authenticity_token
      before_action      :validate_schema, only: [:create]
      
    def create
      user = User.new(@registration_attr)

      if user.save
        render json: { message: 'Thanks for signing up!' }, status: :created
      else
        report_errors_on(user)
      end
    end

    private

      def validate_schema
        validate_json('userRegistration', params.require(:userRegistration))
        if @errors.empty?
          registration_attributes
        else
          render json: {message: @errors}, status: 422
        end
      end

      def registration_attributes
        @registration_attr = convert_hash_keys(params.require(:userRegistration).permit(:firstName, :lastName, :email, :password))
      end
    end
  end
end
