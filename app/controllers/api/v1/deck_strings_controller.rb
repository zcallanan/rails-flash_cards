class Api::V1::DeckStringsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User
  before_action :authenticate_user!
  before_action :set_deck, only: %i[show update]
  before_action :set_deck_string, only: %i[show update]

  def show
    render json: @deck_string and return
  end

  def update
    @user = current_user
    authorize @deck_string
    if @deck_string.update(deck_string_params)

      render json: @deck_string and return
    else
      render_error
    end
  end

  def deck_string_params
    params.require(:deck_string).permit(:language, :title, :description)
  end

  def set_deck
    @deck = Deck.find(params[:deck_id])
  end

  def set_deck_string
    @deck_string = DeckString.find(params[:id])
  end

  def render_error
    render json: { errors: @membership.errors.full_messages },
      status: :unprocessable_entity
  end
end
