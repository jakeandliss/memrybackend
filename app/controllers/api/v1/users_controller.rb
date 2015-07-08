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
    end

      def update
        user = User.find(params[:id])
        if user.update_attributes(user_params)
          render json: { message: 'Your profile has been updated' }, status: :ok
        else
          render json: { error: user.errors }, status: :not_acceptable
        end
      end

      def show
        user = User.find(params[:id])
        if user
          data = {
            'first_name' => user.first_name,
            'last_name' => user.last_name,
            'email' => user.email,
            'avatar' => user.avatar
          }
          render json: { data: data }, status: :ok
        else
          render json: { message: user.errors }, status: :not_found
        end
      end

      def destroy
        if User.find(params[:id]).destroy
          render json: { message: 'Your account is deleted with all your datas' }, status: :ok
        else
          render json: { message: user.errors }, status: :not_found
        end
      end

      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :avatar)
      end

    end
  end
end
