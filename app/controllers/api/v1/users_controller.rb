module Api
  module V1
    class UsersController  < ApplicationController
      skip_before_action :verify_authenticity_token, if: :json_request?
      skip_before_filter  :verify_authenticity_token
      before_action :load_user, only: [:show, :update, :destroy]


    def create
      @user = User.create(user_params)
      if @user.save
        UserMailer.registration_success(@user).deliver_now
        render json: { message: t("user.signup.success") }, status: :created
      else
        render json: { error: @user.errors }, status: :not_acceptable
      end
    end

      def update
        if @user.update_attributes(user_params)
          render json: { message: t("user.update.success") }, status: :ok
        else
          render json: { error: @user.errors }, status: :not_acceptable
        end
      end

      def show
          render 'users.json.jbuilder', status: :ok
      end

      def destroy
        @user.destroy
        render json: { message: t("user.destroy.success") }, status: :ok
      end

      def forgot_password
        @user = User.find_by(email: params[:user][:email])
        if @user
          @user.send_password_reset
          UserMailer.forgot_password(@user).deliver_now
          render json: { message: t("user.forgot_password.success") }, status: :ok
        else
          render json: { error: t("user.common.failure") }, status: :not_found
        end
      end

      def change_password
        user = User.find_by(reset_password_token: params[:user][:token])
        if user
          user.password = params[:user][:password]
          user.reset_password_token = nil
          user.save
          render json: { message: t("user.change_password.success") }, status: :ok
        else
          render json: { error: t("user.change_password.failure") }, status: :not_found
        end
      end

      def check_user
        if User.find_by(email: params[:email])
          render json: { message: t("user.check_user_exists.success") }, status: :ok
        else
          render json: { error: t("user.common.failure") }, status: :not_found
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
