class DeckStringsController < ApplicationController
  before_action :set_deck, only: :update

  def update
    @user = current_user
    @deck_string = DeckString.find(params[:deck_id])
    authorize @deck_string
    if @deck_string.update(deck_string_params)
      redirect_to deck_path(@deck)
    else
      redirect_to 'decks_path'
    end
    return
  end

  def deck_string_params
    params.require(:deck_string).permit(:language, :title, :description)
  end

  def set_deck
    @deck = Deck.find(params[:id])
  end
end
