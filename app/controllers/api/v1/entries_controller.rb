module Api
  module V1
    class EntriesController < Base

      before_action :authenticate_user!
      before_action :set_user   

      def index
        @entries =  @user.entries.preload(:resources)
      end

      def new
      end

      def create
        
      end

      def update
      end

      def destroy
      end

      private

      def set_user
        @user = User.find_by_id(params[:user_id])
        render json: 'User Not Found', status: 422 if @user.blank?
      end

    end
  end
end

