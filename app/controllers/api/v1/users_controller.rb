module Api
  module V1
    class UsersController  < ApplicationController
      skip_before_action :verify_authenticity_token, if: :json_request?
      skip_before_filter  :verify_authenticity_token
      before_action :load_user, only: [:show, :update, :destroy]

      def create
        user = User.create(user_params)
        if user.save
          render json: { message: 'Thanks for signing up!' }, status: :created
        else
          render json: { error: user.errors }, status: :not_acceptable
        end
      end

      def update
        if @user.update_attributes(user_params)
          render json: { message: 'Your profile has been updated.' }, status: :ok
        else
          render json: { error: @user.errors }, status: :not_acceptable
        end
      end

      def show
        @user = User.find(params[:id])
        if @user
          render 'users.json.jbuilder', status: :ok
        else
          render json: { message: 'This is not a registered user.' }, status: :not_found
        end
      end

      def destroy
        if @user
          @user.destroy
          render json: { message: 'Your account is deleted with all your datas.' }, status: :ok
        else
          render json: { message: 'This is not a registered account.' }, status: :not_found
        end
      end

      def forgot_password
        user = User.find_by(email: params[:user][:email])
        if user
          user.send_password_reset
          render json: { message: 'Password recovery link has been sent to your email' }, status: :ok
        else
          render json: { message: 'This is not a registered account.' }, status: :not_found
        end
      end

      def change_password
        user = User.find_by(reset_password_token: params[:user][:token])
        if user
          user.password = params[:user][:password]
          user.reset_password_token = nil
          user.save
          render json: { message: 'Your password is changed successfully.' }, status: :ok
        else
          render json: { message: 'Invalid token.' }, status: :not_found
        end
      end

      private

      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :avatar)
      end

      def load_user
        @user = User.find(params[:id])
      end

    end
  end
end
