class Api::V1::TagsController < Api::V1::BaseController

  def index
    @tags = policy_scope(Tag)

    render json: @tags
  end
end
