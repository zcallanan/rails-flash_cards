class DecksController < ApplicationController
  include Languages
  before_action :set_deck, only: %i[show]
  def index
    @decks = policy_scope(Deck)
    @collections = policy_scope(Collection)

    @deck = Deck.new
    @languages = Languages.list
  end

  def show
    authorize @deck
    @languages = Languages.list
  end

  def create
    authorize @deck
    @user = current_user
    @deck = Deck.new(deck_params)
    # prepare simple_field usage
    @deck.deck_strings.build
  end

  private

  def deck_params
    params.require(:deck).permit(:id_decks, :language, :title, :description)
  end

  def set_deck
    @deck = Deck.find(params[:id])
  end
end
