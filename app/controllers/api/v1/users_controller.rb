module Api
  module V1
    class UsersController  < ApplicationController
      skip_before_action :verify_authenticity_token, if: :json_request?
      skip_before_filter  :verify_authenticity_token

<<<<<<< HEAD

    def create
      user = User.create(user_params)
      if user.save
        render json: { message: 'Thanks for signing up!' }, status: :created
      else
        render json: { error: user.errors }, status: :not_acceptable
=======
      # register new user
      def create
        user = User.new(user_params)
        if user.save
          render json: { message: 'Thanks for signing up!' }, status: :created
        else
          render json: { error: user.errors }, status: :not_acceptable
        end
>>>>>>> action describe comment added
      end
    end

      # update user profile
      def update
        user = User.find(params[:id])
        if user.update_attributes(user_params)
          render json: { message: 'Your profile has been updated' }, status: :ok
        else
          render json: { error: user.errors }, status: :not_acceptable
        end
      end

      # display user profile
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

      # delete user profile
      def destroy
        if User.find(params[:id]).destroy
          render json: { message: 'Your account is deleted with all your datas' }, status: :ok
        else
          render json: { message: user.errors }, status: :not_found
        end
      end

      # user forgot password request
      def forgot_password
        user = User.find_by_email!(params[:user][:email])
        user.send_password_reset if user
        render json: { message: 'Password recovery link has been sent to your email' }, status: :ok
      end

      # user change password
      # validates token in get request
      # updates password in put request
      def change_password
        user = User.find_by_reset_password_token(params[:id])
        if request.get?
          if user
            render json: { message: 'Token is valid.' }, status: :ok
          else
            render json: { message: 'Invalid token.' }, status: :not_found
          end
        elsif request.put?
          user.password = params[:user][:password]
          user.reset_password_token = nil
          if user.save
            render json: { message: 'Your password is changed successfully.' }, status: :ok
          else
            render json: { error: user.errors }, status: :not_acceptable
          end
        else
          render json: { message: 'Invalid request.' }, status: :not_acceptable
        end
      end

      # check if user already exists
      def check_user_exists
        user = User.find_by_email(params[:email]);
        if user
          render json: { message: 'User already exits.' }, status: :ok
        else
          render json: { message: 'User not found' }, status: :not_found
        end
      end

      private
      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :avatar)
      end

    end
  end
end
