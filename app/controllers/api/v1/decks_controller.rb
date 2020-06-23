class Api::V1::DecksController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User
  before_action :set_deck, only: %i[update]

  def update
    authorize(@deck)
    if @deck.update!(deck_params)
      render json: @deck
    else
      render_error
    end
  end

  private

  def deck_params
    params.require(:deck).permit(
      :default_language,
      :global_deck_read,
      :archived,
      collections_attributes: [collection_strings_attributes:
        [:language, :title, :description]],
      deck_strings_attributes: [:language, :title, :description]
    )
  end

  def set_deck
    @deck = Deck.find(params[:id])
  end

  def render_error
    render json: { errors: @membership.errors.full_messages },
      status: :unprocessable_entity
  end
end
