class Api::V1::TagsController < ApplicationController
  skip_before_action :verify_authenticity_token, if: :json_request?
  skip_before_filter  :verify_authenticity_token
  before_action :ancestor_tag, only: [:create]
  before_action :load_tag, only: [:update, :destroy]

  def create
    @tag = Tag.create!(name: params[:tag][:name], user_id: 22, ancestry: @ancestor_tag)
    if @tag.save
      render json: { message: t("tags.create.success") }, status: :created
    else
      render json: { error: @tag.errors }, status: :not_acceptable
    end
  end

  def update
    @tag.name = params[:tag][:name]
    @tag.ancestry = params[:tag][:parent] if params[:tag][:parent]
    if @tag.save
      render json: { message: t("tags.update.success") }, status: :ok
    else
      render json: { error: @tag.errors }, status: :not_acceptable
    end
  end

  def destroy
    @tag.destroy
    render json: { message: t("tags.destroy.success") }, status: :ok
  end

  def user_tags
    @show_tag = Tag.find_by(user: 22 )
    render 'tags.json.jbuilder', status: :ok
  end

  private

  def ancestor_tag
    @ancestor_tag = nil;
    if params[:tag][:parent]
      tag = Tag.find(params[:tag][:parent])
      @ancestor_tag = tag.id
    end
  end

  def load_tag
    @tag = Tag.find(params[:id])
  end

end
