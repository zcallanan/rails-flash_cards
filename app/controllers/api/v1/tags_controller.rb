class Api::V1::TagsController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    @tags = policy_scope(Tag)

    render json: @tags
  end
end
