class Api::V1::RegistrationsController < Devise::RegistrationsController

  def create
    user = User.new(user_params)
    if user.save
      render :json => {
                 :status => 201,
                 :message => 'Your account has been created',
                 :user => {
                     :email => user.email
                 }
             }
      return
    else
      warden.custom_failure!
      render :json => user.errors, :status => 422
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :avatar)
  end

end
