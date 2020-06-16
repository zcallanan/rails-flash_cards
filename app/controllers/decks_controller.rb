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
    @decks_read_strings = []
    @decks_read.each do |deck|
      deck.deck_strings.each do |string|
        string.deck_permissions.each do |permission|
          @decks_read_strings << string if string.language == permission.language && permission.user_id == @user.id
        end
      end
    end

    # list of decks that are globally available
    @decks_global_strings = []
    @decks_global = policy_scope(Deck).where(global_deck_read: true)
    @decks_global.each do |deck|
      deck.deck_strings.each do |string|
        @decks_global_strings << string if string.global_access == true
      end
    end

    @collections = policy_scope(Collection)

    @deck = Deck.new
    @languages = Languages.list
  end

  def show
    @deck_strings = @deck.deck_strings
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
