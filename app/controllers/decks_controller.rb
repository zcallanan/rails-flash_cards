class DecksController < ApplicationController
  def index
    @decks = policy_scope(Deck)
    @collections = policy_scope(Collection)
  end

  def show
    @deck = Deck.find(params[:id])
    authorize @deck
  end
end
