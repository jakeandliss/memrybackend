module Api
  module V1
    class UsersController  < ApplicationController
      skip_before_action :verify_authenticity_token, if: :json_request?
      skip_before_filter  :verify_authenticity_token

    def create
      user = User.create(user_params)
      if user.save
        render json: { message: 'Thanks for signing up!' }, status: :created
      else
        render json: { error: user.errors }, status: :not_acceptable
      end

      def update
        user = User.find(params[:id])
        if user.update_attributes(user_params)
          render json: { message: 'Your profile has been updated' }, status: :ok
        else
          render json: { error: user.errors }, status: :not_acceptable
        end
      end


      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :avatar)
      end

    end
  end
end
