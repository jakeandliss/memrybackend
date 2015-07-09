class Api::V1::TagsController < ApplicationController
  skip_before_action :verify_authenticity_token, if: :json_request?
  skip_before_filter  :verify_authenticity_token
  before_action :ancestor_tag, only: [:create]

  def create
    @tag = Tag.create!(name: params[:tag][:name], user_id: 22, ancestry: @ancestor_tag)
    if @tag.save
      render json: { message: "New tag created" }, status: :created
    else
      render json: { error: @tag.errors }, status: :not_acceptable
    end
  end


  private
  def ancestor_tag
    @ancestor_tag = nil;
    if params[:tag][:parent]
      tag = Tag.find(params[:tag][:parent])
      @ancestor_tag = tag.id
    end
  end

end
