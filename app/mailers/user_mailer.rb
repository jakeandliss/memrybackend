class UserMailer < ApplicationMailer

  def registration_success(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to MemryBook')
  end

  def forgot_password(user)
    @user = user
    @change_password_url  = 'http://memrybook.com/#/change-password/'+@user.reset_password_token
    mail(to: @user.email , subject: 'Forgot password')
  end

end
