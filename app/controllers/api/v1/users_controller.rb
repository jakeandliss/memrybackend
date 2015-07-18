module Api
  module V1
    class UsersController  < Base
      skip_before_action :authenticate_user!, only: [:create]
      skip_before_action :verify_authenticity_token, if: :json_request?
      before_action      :validate_schema, only: [:create, :update]
      before_action      :load_user, only: [:show, :update, :destroy]

      def create
        @user = User.new @user_attr

        if @user.save
          UserMailer.registration_success(@user).deliver_later
        else
          report_errors_on(@user)
        end
      end

      def update
        if @user.update_attributes @user_attr
          render json: { message: t("user.update.success") }, status: :ok
        else
          render json: { error: @user.errors }, status: :not_acceptable
        end
      end

      def show
      end

      def destroy
        @user.destroy
        render json: { message: t("user.destroy.success") }, status: :ok
      end

      def forgot_password
        @user = User.find_by email: params[:user][:email]
        if @user
          @user.send_password_reset
          UserMailer.forgot_password(@user).deliver_later!
          render json: { message: t("user.forgot_password.success") }, status: :ok
        else
          render json: { error: t("user.common.failure") }, status: :not_found
        end
      end

      def change_password
        user = User.find_by reset_password_token: params[:user][:token]
        if user
          user.password = params[:user][:password]
          user.reset_password_token = nil
          user.save
          render json: { message: t("user.change_password.success") }, status: :ok
        else
          render json: { error: t("user.change_password.failure") }, status: :not_found
        end
      end

      def validate_email
        if User.find_by email: params[:user][:email]
          render json: { message: t('user.validate_email.error') }, status: :ok
        else
          render json: { message: t('user.validate_email.success')}, status: :ok
        end
      end

      private

      def user_attributes
        @user_attr = convert_hash_keys(params.require(:userRegistration).permit(:firstName, :lastName, :email, :password))
      end

      def load_user
        @user = User.find(params[:id])
      end

      def validate_schema
        validate_json('userRegistrationForm', params.require(:userRegistration))
        if @errors.empty?
          user_attributes
        else
          render json: { message: @errors }, status: :unprocessable_entity
        end
      end
    end
  end
end
