module Api
  module V1
    class EntriesController < Base

      # Both lines below should be removed once auth is working and we have
      # current_user
      before_action :get_user
      attr_accessor :current_user

      def index
        @entry = current_user.entries.new(:title_date => Date.today)
        @tags = current_user.tags(:parent_id => params[:parent_id])

        if params[:tag]
          # filter using search
          @tag = Tag.find_by(name: params[:tag])
          @entries = @tag ? 
                      current_user.entries.childrens_of(@tag).paginate(:page => params[:page], :per_page => 10)
                      : current_user.entries.paginate(:page => params[:page], :per_page => 10)
        else
          # fetch all entries of the user
          @entries = current_user.entries.paginate(:page => params[:page], :per_page => 10)
        end

        # Add search function call here while merging feature/search-api branch

        render json: { entries: @entries }, status: :ok
      end

      private
      
      def date_filters
        start = params[:start] ? params[:start].to_date : nil
        finish = params[:finish] ? params[:finish].to_date : nil
        return {
          start: start,
          finish: finish
        }
      end

      # Remove method when auth is working and current_user helper method is used
      def get_user
        @current_user = User.first
      end
  
    end
  end
end
