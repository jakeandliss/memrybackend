class Api::V1::RegistrationsController < Devise::RegistrationsController

  def create
    user = User.new(user_params)
    avatar_uploaded_path = upload_avatar(params[:user][:avatar_file_name])
    user.avatar_file_name = avatar_uploaded_path
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

  def upload_avatar(avatar_path)
    filename = avatar_path.split('/')
    FileUtils.cp_r avatar_path, Rails.public_path
    return request.base_url+'/'+filename[-1]
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :avatar_file_name)
  end

end
