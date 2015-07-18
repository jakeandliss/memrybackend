module Api
  module V1
    class EntriesController < Base

      # Both lines below should be removed once auth is working and we have
      # current_user as a helper method this is just a mock setup to mimic
      # current_user method of device gem
        before_action :get_user
        attr_accessor :current_user
      # Remove lines above this comment when auth is working

      before_action :validate_schema, only: [:create, :update]
      before_action :fetch_entry, only: [:show, :edit, :update, :destroy]

      def index
        @entry = current_user.entries.new(:title_date => Date.today)
        @tags = current_user.tags(:parent_id => params[:parent_id])

        if params[:tag]
          # filter using search
          @tag = current_user.tags.find_by(name: params[:tag])
          #TODO Refactor the paginate code used thrice
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


      def create
        @entry = current_user.entries.new(entry_attributes)

        if @entry.save && @entry.add_tags(params[:entry][:all_tags])
          render json: { 
            message: "Entry sucessfully created", 
            entry: @entry.as_json(:include => :tags) 
          }, status: :ok
        else
          render json: { 
            message: "Entry couldn't be created", 
            errors: @entry.errors 
          }, status: :unprocessable_entity
        end
      end

      def show
        if @entry
          render json: { 
            entry: @entry.as_json(:include => :tags)
          }, status: :ok
        else
          render json: {
            message: "Entry with id #{params[:id]} not found"
          }, status: :not_found
        end
      end

      def update
        if @entry.update_attributes!(entry_attributes) && @entry.add_tags(params[:entry][:all_tags])
          render json: {
            message: "Entry sucessfully updated",
            entry: @entry.as_json(:include => :tags)
          }, status: :ok
        else
          render json: {
            message: "Entry couldn't be updated",
            errors: @entry.errors
          }, status: :unprocessable_entity
        end
      end

      def destroy
        if @entry and @entry.destroy
          render json: {
            message: "Entry deleted successfully"
          }, status: :ok
        end
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

      def entry_attributes
        @entry_attr = convert_hash_keys(
          params.require(:entry)
            .permit(:title, :content, :titleDate, :resourceIds => [])
        )
      end

      # Remove method when auth is working and current_user helper method is used
      def get_user
        @current_user = User.first
      end
  
      def validate_schema
        validate_json('entryForm', params.require(:entry))
        if @errors.empty?
          entry_attributes
        else
          render json: { message: @errors }, status: :unprocessable_entity
        end
      end

      def fetch_entry
        @entry = current_user.entries.where(id: params[:id]).first
      end

    end
  end
end
