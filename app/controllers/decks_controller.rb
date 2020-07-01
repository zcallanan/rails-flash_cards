class DecksController < ApplicationController
  include Languages
  before_action :set_deck, only: %i[show update]
  def index
    @user = current_user

    # list of decks the user owns
    @decks_owned = policy_scope(Deck).where(user: @user).where.not(archived: true)
    kwargs = {
      objects: @decks_owned, user: @user, string_type: 'deck_strings', id_type: :deck_id, permission_type: nil, deck: nil
    }
    @decks_owned_strings = populate_strings(kwargs)

    # list of archived decks
    @decks_archived = policy_scope(Deck).where(user: @user, archived: true)
    kwargs = {
      objects: @decks_archived, user: @user, string_type: 'deck_strings', id_type: :deck_id, permission_type: nil, deck: nil
    }
    @decks_archived_strings = populate_strings(kwargs)

    # list of decks the user can read but does not own
    @decks_read = policy_scope(Deck)
                  .joins(:deck_permissions)
                  .where({ deck_permissions: { user_id: @user.id, read_access: true, update_access: false } })
                  .where.not(user: @user).distinct
    kwargs = {
      objects: @decks_read, user: @user, string_type: 'deck_strings', id_type: :deck_id, permission_type: 'deck_permissions', deck: nil
    }
    @decks_read_strings = populate_strings(kwargs)

    # list of decks the user can read & update but does not own
    @decks_update = policy_scope(Deck)
                    .joins(:deck_permissions)
                    .where({ deck_permissions: { user_id: @user.id, read_access: true, update_access: true } })
                    .where.not(user: @user).distinct
    kwargs = {
      objects: @decks_update, user: @user, string_type: 'deck_strings', id_type: :deck_id, permission_type: 'deck_permissions', deck: nil
    }
    @decks_update_strings = populate_strings(kwargs)

    # # list of decks that are globally available
    # @decks_global = policy_scope(Deck).where(global_deck_read: true, archived: false)
    # kwargs = {
    #   objects: @decks_global, user: @user, string_type: 'deck_strings', id_type: :deck_id, permission_type: nil, deck: nil
    # }
    # @decks_global_strings = populate_strings(kwargs)

    @deck = Deck.new
    # prepare simple_field usage
    @deck.deck_strings.build
    @collection = @deck.collections.build
    @collection_string = @collection.collection_strings.build
    @languages = Languages.list
  end

  def show
    @user = current_user
    authorize @deck
    @deck_strings = @deck.deck_strings
    @languages = Languages.list
    @deck_string = DeckString.new
    @collection = Collection.new
    @collection_string = CollectionString.new
    @collection.user = @user # enable view's evaluation of collection policy create?
    @collection_string.user = @user
    # prepare simple_field usage
    @collection.collection_strings.build
    # TODO: may require a joins to eliminate archived deck data
    @collections_owned = policy_scope(Collection).where(user: @user)
    kwargs = {
      objects: @collections_owned, user: @user, string_type: 'collection_strings', id_type: :collection_id, permission_type: nil, deck: 'deck'
    }
    @collections_owned_strings = populate_strings(kwargs)

    # list of collections the user can read but does not own
    @collections_read = policy_scope(Collection)
                        .joins(:collection_permissions)
                        .where({ collection_permissions: { user_id: @user.id, read_access: true, update_access: false } })
                        .where.not(user: @user).distinct
    kwargs = {
      objects: @collections_read, user: @user, string_type: 'collection_strings', id_type: :collection_id, permission_type: 'collection_permissions', deck: 'deck'
    }
    @collections_read_strings = populate_strings(kwargs)

    # list of collections the user can read & update but does not own
    @collections_update = policy_scope(Collection)
                          .joins(:collection_permissions)
                          .where({ collection_permissions: { user_id: @user.id, read_access: true, update_access: true } })
                          .where.not(user: @user).distinct
    kwargs = {
      objects: @collections_update, user: @user, string_type: 'collection_strings', id_type: :collection_id, permission_type: 'collection_permissions', deck: 'deck'
    }
    @collections_update_strings = populate_strings(kwargs)

    @languages = Languages.list
    @language_options = [] # when updating a deck, user can change what language strings users see by default, if they exist. User preference overrides this
    @reduced_languages = {} # remove language options from language list if a string exists in that language
    language_collection = @deck.deck_strings.pluck(:language)
    @languages.each do |key, value|
      language_collection.include?(value) ? @language_options << [key, value] : @reduced_languages[key] = value
    end
  end

  def create
    @user = current_user
    @deck = Deck.new(deck_params)
    @deck.user = @user
    @deck.deck_strings.first.user = @user
    @deck.collections.first.user = @user
    @deck.collections.first.collection_strings.first.user = @user
    @deck.collections.first.collection_strings.first.user
    authorize @deck
    if @deck.save!
      @deck.update!(default_language: @deck.deck_strings.first.language) # first string sets the default language
      DeckPermission.create!(
        deck: @deck,
        user: @user,
        deck_string: @deck.deck_strings.first,
        read_access: true,
        update_access: true,
        clone_access: true
      )
      CollectionPermission.create!(
        collection: @deck.collections.first,
        user: @user,
        collection_string: @deck.collections.first.collection_strings.first,
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
    if @deck.update!(deck_params)
      redirect_to deck_path(@deck)
    else
      redirect_to decks_path, flash[:alert] = "Unable to update"
    end
  end

  private

  def populate_strings(**kwargs)
    # objects ~ decks, string_type ~ 'deck_strings', id_type ~ :deck_id, permission_type ~ 'deck_permissions'
    object_strings = []
    kwargs[:objects].each do |object|
      # prioritize strings that have a user's preferred language
      next if object_strings.pluck(kwargs[:id_type]).include?(object.id)

      languages = object.send(kwargs[:string_type]).pluck(:language)
      if languages.include?(kwargs[:user].language)
        object.send(kwargs[:string_type]).each do |string|
          if string.language == kwargs[:user].language && kwargs[:permission_type].nil?
            object_strings << string
          elsif string.language == kwargs[:user].language
            string.send(kwargs[:permission_type]).each do |permission|
              object_strings << string if string.language == permission.language && permission.user_id == kwargs[:user].id
            end
          end
        end
      else
        # otherwise, return strings of the default language
        object.send(kwargs[:string_type]).each do |string|
          if string.language == object.default_language && kwargs[:deck].nil?
            object_strings << string
          elsif string.language == object.send(kwargs[:deck]).default_language && !kwargs[:deck].nil?
            object_strings << string
          end
        end
      end
    end
    object_strings
  end

  def deck_params
    params.require(:deck).permit(
      :default_language,
      :global_deck_read,
      :archived,
      collections_attributes: [collection_strings_attributes:
        [:language, :title, :description]],
      deck_strings_attributes: [:language, :title, :description]
    )
  end

  def set_deck
    @deck = Deck.find(params[:id])
  end
end
