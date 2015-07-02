class Api::V1::RegistrationsController < ApplicationController

  skip_before_action :verify_authenticity_token, if: :json_request?

  def create
    user = User.new(user_params)
    if user.save
      render :json => {
                 :status => 201,
                 :message => 'Your account has been created'
             }
    else
      render :json => user.errors, :status => 422
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :avatar)
  end

end
