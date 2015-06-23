class Api::V1::RegistrationsController < Devise::RegistrationsController


  def create
    user = User.new(user_params)
    avatar_uploaded_path = upload_profile_pic(params[:user][:profile_pic])
    user.profile_pic = avatar_uploaded_path
    if user.save
      render :json => user.as_json(:email => user.email), :status => 201
      return
    else
      warden.custom_failure!
      render :json => user.errors, :status => 422
    end
  end

  def upload_profile_pic(avatar_path)
    filename = avatar_path.split('/')
    FileUtils.cp_r avatar_path, Rails.public_path
    return request.base_url+'/'+filename[-1]
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :profile_pic)
  end

end
