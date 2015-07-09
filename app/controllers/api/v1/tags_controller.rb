class Api::V1::TagsController < ApplicationController
  skip_before_action :verify_authenticity_token, if: :json_request?
  skip_before_filter  :verify_authenticity_token
  before_action :ancestor_tag, only: [:create, :destroy]

  def create
    @tag = Tag.create!(name: params[:name], user_id: 22, ancestry: @ancestor_tag.id)
    if @tag.save
      render json: { message: "New tag created" }, status: :created
    else
      render json: { error: @tag.errors }, status: :not_acceptable
    end
  end

  def destroy
    @ancestor_tag.destroy
    render json: { message: "Tag deleted successfully" }, status: :ok
  end


  private
  def ancestor_tag
    @ancestor_tag = nil;
    if params[:id]
      @ancestor_tag = Tag.find(params[:id])
    end
  end

end
