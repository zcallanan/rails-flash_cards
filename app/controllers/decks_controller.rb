class DecksController < ApplicationController
  def index
    @decks = policy_scope(Deck)
  end
end
