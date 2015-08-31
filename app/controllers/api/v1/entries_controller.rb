module Api
  module V1
    class EntriesController < Base

      before_action :authenticate_user!
      before_action :set_user   

      def index
        @entries =  @user.entries.preload(:resources)
      end

      def show
        @entry = @user.entries.where(id: params[:id] ).first
        render json: "Entry Not found", status: 422 if @entry.blank?
      end

      def create
        @entry = @user.entries.build(entry_params)
        unless @entry.save
          render json: {error: @entry.errors.full_messages.join(', ')}, status: 422
        end
      end

      def update
        @entry = @user.entries.where(id: params[:id] ).first
        if @entry.present?
          unless @entry.update_attributes(entry_params)
            render json: {error: @entry.errors.full_messages.join(', ')}, status: 422
          end
        else
          render json: "Entry Not found", status: 422
        end
      end

      def destroy
        @entry = @user.entries.where(id: params[:id] ).first
        if @entry.present?
          if @entry.destroy
            render json: 'Entry deleted successfully', status: 200 
          else
            render json: 'Sorry! Entry cannot be deleted now', status: 422
          end
        else
          render json: "Entry Not found", status: 422 
        end
      end

      private

      def set_user
        @user = User.find_by_id(params[:user_id])
        render json: 'User Not Found', status: 422 if @user.blank?
      end

      def entry_params
        params.require(:entry).permit(:title, :content, resources_attributes: [:attachment] )
      end
    end
  end
end

