class Api::V1::CollectionStringsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User
  before_action :set_deck, only: %i[update]
  before_action :set_collection, only: %i[update]
  before_action :set_collection_string, only: %i[update]

  def update
    @user = current_user
    authorize @collection_string
    if @collection_string.update(collection_string_params)

      render json: @collection_string and return
    else
      render_error
    end
  end

  private

  def collection_string_params
    params.require(:collection_string).permit(:title, :description, :language)
  end

  def set_deck
    @deck = Deck.find(params[:deck_id])
  end

  def set_collection
    @collection = Collection.find(params[:collection_id])
  end

  def set_collection_string
    @collection_string = CollectionString.find(params[:id])
  end

  def render_error
    render json: { errors: @membership.errors.full_messages },
      status: :unprocessable_entity
  end
end
