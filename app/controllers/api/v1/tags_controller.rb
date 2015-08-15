module Api
  module V1
    class TagsController < ApplicationController
      skip_before_action :verify_authenticity_token, if: :json_request?
      before_action :ancestor_tag, only: [:create]
      before_action :load_tag, only: [:update, :destroy]

      def create
        tag = Tag.create_tag!(@tag_attr)

        if tag.save
          render json: { message: t("tags.create.success") }, status: :created
        else
          render json: { error: @tag.errors }, status: :unprocessable_entity
        end
      end

      def update
        @tag.update_tag!(@tag_attr)

        if @tag.save
          render json: { message: t("tags.update.success") }, status: :ok
        else
          render json: { error: @tag.errors }, status: :not_acceptable
        end
      end

      def destroy
        @tag.destroy!
        render json: { message: t("tags.destroy.success") }, status: :ok
      end

      def index
        @user_tags = current_user.tags
      end

      private

      def ancestor_tag
        @ancestor_tag = nil;
        if params[:tag][:parent]
          tag = Tag.find(params[:tag][:parent])
          @ancestor_tag = tag.id
        end
      end

      def validate_schema
        validate_json('tagForm', params.require(:tag))
        if @errors.empty?
          tag_attributes
        else
          render json: { message: @errors }, status: :unprocessable_entity
        end
      end

      def tag_attributes
        @tag_attr = convert_hash_keys(params.require(:tag).permit(:name, :userId, :ancestry))
      end

      def load_tag
        @tag = Tag.find(params[:tag][:id])
      end
    end
  end
end