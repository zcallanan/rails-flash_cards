class DeckStringsController < ApplicationController
  before_action :set_deck, only: :update

  def update
    @user = current_user
    @deck_string = DeckString.find(params[:deck_id])
    @deck_string.update(deck_string_params)

    redirect_to deck_path(@deck)
    authorize @deck_string
  end

  def deck_string_params
    params.require(:deck_string).permit(:language, :title, :description)
  end

  def set_deck
    @deck = Deck.find(params[:id])
  end
end
