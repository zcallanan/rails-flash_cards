class DecksController < ApplicationController
  include Languages
  before_action :set_deck, only: %i[show update]
  def index
    @user = current_user

    # list of decks the user owns
    @decks_owned = policy_scope(Deck).where(user: @user).where.not(archived: true)
    @decks_owned_strings = populate_strings(@decks_owned, @user)

    # list of archived decks
    @decks_archived = policy_scope(Deck).where(user: @user, archived: true)
    @decks_archived_strings = populate_strings(@decks_archived, @user)

    # list of decks the user can read but does not own
    @decks_read = policy_scope(Deck)
                  .joins(:deck_permissions)
                  .where({ deck_permissions: { user_id: @user.id, read_access: true, update_access: false } })
                  .where.not(user: @user).distinct
    @decks_read_strings = populate_strings(@decks_read, @user, 1)

    # list of decks the user can read & update but do not own
    @decks_update = policy_scope(Deck)
                    .joins(:deck_permissions)
                    .where({ deck_permissions: { user_id: @user.id, read_access: true, update_access: true } })
                    .where.not(user: @user).distinct
    @decks_update_strings = populate_strings(@decks_update, @user, 1)

    # list of decks that are globally available
    @decks_global = policy_scope(Deck).where(global_deck_read: true, archived: false)
    @decks_global_strings = populate_strings(@decks_global, @user)

    @collections = policy_scope(Collection)

    @deck = Deck.new
    @languages = Languages.list
  end

  def show
    authorize @deck
    @deck_strings = @deck.deck_strings
    @languages = Languages.list
  end

  def create
    authorize @deck
    @user = current_user
    @deck = Deck.new(deck_params)
    # prepare simple_field usage
    @deck.deck_strings.build
  end

  def update
    authorize(@deck)
    if @deck.update(deck_params)
      redirect_to decks_path
    else
      redirect_to deck_path(@deck), flash[:alert] = "Unable to update"
    end
  end

  private

  def populate_strings(decks, user, permissions = nil)
    object_strings = []
    decks.each do |deck|
      next if object_strings.pluck(:deck_id).include?(deck.id)

      languages = deck.deck_strings.pluck(:language)
      if languages.include?(user.language)
        deck.deck_strings.each do |string|
          if string.language == user.language && permissions.nil?
            object_strings << string
          elsif string.language == user.language
            string.deck_permissions.each do |permission|
              object_strings << string if string.language == permission.language && permission.user_id == user.id
            end
          end
        end
      else
        object_strings << deck.deck_string[0]
      end
    end
    object_strings
  end

  def deck_params
    params.require(:deck).permit(:id_decks, :language, :title, :description, :global_deck_read, :archived)
  end

  def set_deck
    @deck = Deck.find(params[:id])
  end
end
