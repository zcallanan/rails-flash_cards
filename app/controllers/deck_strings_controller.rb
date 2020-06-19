class DeckStringsController < ApplicationController
  before_action :set_deck, only: %i[create update]
  before_action :set_deck_string, only: %i[update]

  def create
    @deck_string = DeckString.new(deck_string_params)
    @deck_string.user = current_user
    @deck_string.deck = @deck
    authorize(@deck_string)
    if @deck_string.save!
      redirect_to deck_path(@deck)
    else
      redirect_to decks_path
    end
  end

  def update
    @user = current_user
    authorize @deck_string
    if @deck_string.update!(deck_string_params)
      redirect_to deck_path(@deck)
    else
      redirect_to decks_path
    end
    return
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
end
