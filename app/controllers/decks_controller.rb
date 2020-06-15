class DecksController < ApplicationController
  include Languages
  before_action :set_deck, only: %i[show]
  def index
    @user = current_user
    # list of decks the user owns
    @decks_owned = policy_scope(Deck).where(user: @user)
    # list of decks the user can read but does not own
    @decks_read = policy_scope(Deck)
                  .joins(:deck_permissions)
                  .where({ deck_permissions: { user_id: @user.id, read_access: true } })
                  .where.not(user: @user)
    # list of decks that are globally available
    @decks_global = policy_scope(Deck).where(global_deck_read: true)
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
