module Api
  module V1
    class UsersController  < ApplicationController

    def create
      user = User.new(user_params)
      if user.save
        render :json => { :status => :ok, :message => 'Thanks for signing up!'}
      else
        render :json => user.errors, :status => :error
      end
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :avatar)
    end

    end

  end

end
