class DecksController < ApplicationController
  include Languages
  before_action :set_deck, only: %i[show update]
  def index
    @user = current_user

    # list of decks the user owns
    @decks_owned = policy_scope(Deck).where(user: @user).where.not(archived: true)
    @decks_owned_strings = populate_strings(@decks_owned, @user, 'deck_strings', :deck_id)

    # list of archived decks
    @decks_archived = policy_scope(Deck).where(user: @user, archived: true)
    @decks_archived_strings = populate_strings(@decks_archived, @user, 'deck_strings', :deck_id)

    # list of decks the user can read but does not own
    @decks_read = policy_scope(Deck)
                  .joins(:deck_permissions)
                  .where({ deck_permissions: { user_id: @user.id, read_access: true, update_access: false } })
                  .where.not(user: @user).distinct
    @decks_read_strings = populate_strings(@decks_read, @user, 'deck_strings', :deck_id, 'deck_permissions')

    # list of decks the user can read & update but do not own
    @decks_update = policy_scope(Deck)
                    .joins(:deck_permissions)
                    .where({ deck_permissions: { user_id: @user.id, read_access: true, update_access: true } })
                    .where.not(user: @user).distinct
    @decks_update_strings = populate_strings(@decks_update, @user, 'deck_strings', :deck_id, 'deck_permissions')

    # list of decks that are globally available
    @decks_global = policy_scope(Deck).where(global_deck_read: true, archived: false)
    @decks_global_strings = populate_strings(@decks_global, @user, 'deck_strings', :deck_id)

    @deck = Deck.new
    # prepare simple_field usage
    @deck.deck_strings.build
    @languages = Languages.list
  end

  def show
    @user = current_user
    authorize @deck
    @deck_strings = @deck.deck_strings
    @languages = Languages.list
    @collection = Collection.new
    @collection.user = @user # enable view's evaluation of collection policy create?
    # prepare simple_field usage
    @collection.collection_strings.build
    # TODO: may require a joins to eliminate archived deck data
    @collections_owned = policy_scope(Collection).where(user: @user)
    @collections_owned_strings = populate_strings(@collections_owned, @user, 'collection_strings', :collection_id)

    # list of decks the user can read but does not own
    @collections_read = policy_scope(Collection)
                        .joins(:collection_permissions)
                        .where({ collection_permissions: { user_id: @user.id, read_access: true, update_access: false } })
                        .where.not(user: @user).distinct
    @collections_read_strings = populate_strings(@collections_read, @user, 'collection_strings', :collection_id, 'collection_permissions')

    # list of decks the user can read & update but do not own
    @collections_update = policy_scope(Collection)
                          .joins(:collection_permissions)
                          .where({ collection_permissions: { user_id: @user.id, read_access: true, update_access: true } })
                          .where.not(user: @user).distinct
    @collections_update_strings = populate_strings(@collections_update, @user, 'collection_strings', :collection_id, 'collection_permissions')
  end

  def create
    @user = current_user
    @deck = Deck.new(deck_params)
    @deck.user = @user
    authorize @deck
    if @deck.save!
      DeckPermission.create(
        deck: @deck,
        user: @user,
        deck_string: @deck.deck_strings.first,
        read_access: true,
        update_access: true,
        clone_access: true
      )
      redirect_to deck_path(@deck)
    else
      redirect_to decks_path
    end
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

  def populate_strings(objects, user, string_type, id_type, permission_type = nil)
    object_strings = []
    objects.each do |object|
      next if object_strings.pluck(id_type).include?(object.id)

      languages = object.send(string_type).pluck(:language)
      if languages.include?(user.language)
        object.send(string_type).each do |string|
          if string.language == user.language && permission_type.nil?
            object_strings << string
          elsif string.language == user.language
            string.send(permission_type).each do |permission|
              object_strings << string if string.language == permission.language && permission.user_id == user.id
            end
          end
        end
      else
        object_strings << object.send(string_type)[0]
      end
    end
    object_strings
  end

  def deck_params
    params.require(:deck).permit(:global_deck_read, :archived, deck_strings_attributes: [:language, :title, :description])
  end

  def set_deck
    @deck = Deck.find(params[:id])
  end
end
