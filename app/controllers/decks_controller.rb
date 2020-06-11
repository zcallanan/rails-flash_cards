class DecksController < ApplicationController
  def index
    @decks = policy_scope(Deck)
  end

  def show
    @deck = Deck.find(params[:id])
    authorize @deck

  end
end
