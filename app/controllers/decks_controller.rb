class DecksController < ApplicationController
  include Languages
  before_action :set_deck, only: %i[show]
  def index
    @user = current_user
    # TODO: break out string definition into a generalized method
    # list of decks the user owns
    @decks_owned = policy_scope(Deck).where(user: @user)
    @decks_owned_strings = []
    @decks_owned.each do |deck|
      next if @decks_owned_strings.pluck(:deck_id).include?(deck.id)

      languages = deck.deck_strings.pluck(:language)
      if languages.include?(@user.language)
        deck.deck_strings.each { |string| @decks_owned_strings << string if string.language == @user.language }
      else
        @decks_owned_strings << deck.deck_string[0]
      end
    end
    # list of decks the user can read but does not own
    @decks_read = policy_scope(Deck)
                  .joins(:deck_permissions)
                  .where({ deck_permissions: { user_id: @user.id, read_access: true } })
                  .where.not(user: @user).distinct
    @decks_read_strings = []
    @decks_read.each do |deck|
      next if @decks_read_strings.pluck(:deck_id).include?(deck.id)

      languages = deck.deck_strings.pluck(:language)
      if languages.include?(@user.language)
        deck.deck_strings.each do |string|
          string.deck_permissions.each do |permission|
            if string.language == @user.language && string.language == permission.language && permission.user_id == @user.id
              @decks_read_strings << string
            end
          end
        end
      else
        @decks_owned_strings << deck.deck_string[0]
      end
    end

    # TODO: Account for language
    # list of decks that are globally available
    @decks_global_strings = []
    @decks_global = policy_scope(Deck).where(global_deck_read: true)
    @decks_global.each do |deck|
      next if @decks_global_strings.pluck(:deck_id).include?(deck.id)

      languages = deck.deck_strings.pluck(:language)
      if languages.include?(@user.language)
        deck.deck_strings.each do |string|
          @decks_global_strings << string if string.global_access == true
        end
      else
        deck.deck_strings.each do |string|
          if string.global_access?
            @decks_global_strings << string
            break
          end
        end
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
