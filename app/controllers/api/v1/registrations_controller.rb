class Api::V1::RegistrationsController < Devise::RegistrationsController


  def create
    user = User.new(user_params)
    if user.save
      render :json => user.as_json(:email => user.email), :status => 201
      return
    else
      warden.custom_failure!
      render :json => user.errors, :status => 422
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

end
