class DecksController < ApplicationController
  include Languages
  before_action :set_deck, only: %i[show update]

  def index
    @user = current_user

    # list of decks the user owns
    @decks_owned = policy_scope(Deck).my_decks_owned(@user, false)
    decks_owned_strings = {
      objects: @decks_owned, user: @user, string_type: 'deck_strings', id_type: :deck_id, permission_type: nil, deck: nil
    }
    # app/controllers/concerns/populate_strings
    @decks_owned_strings = PopulateStrings.new(decks_owned_strings).call

    # list of archived decks
    @decks_archived = policy_scope(Deck).my_decks_owned(@user, true)
    archived_deck_strings = {
      objects: @decks_archived, user: @user, string_type: 'deck_strings', id_type: :deck_id, permission_type: nil, deck: nil
    }
    @decks_archived_strings = PopulateStrings.new(archived_deck_strings).call

    # list of decks the user can read but does not own
    @decks_read = policy_scope(Deck).my_decks_not_owned(@user, false)
    targeted_read_strings = {
      objects: @decks_read, user: @user, string_type: 'deck_strings', id_type: :deck_id, permission_type: 'deck_permissions', deck: nil
    }
    @decks_read_strings = PopulateStrings.new(targeted_read_strings).call

    # list of decks the user can read & update but does not own
    @decks_update = policy_scope(Deck).my_decks_not_owned(@user, true)
    targeted_update_strings = {
      objects: @decks_update, user: @user, string_type: 'deck_strings', id_type: :deck_id, permission_type: 'deck_permissions', deck: nil
    }
    @decks_update_strings = PopulateStrings.new(targeted_update_strings).call

    # create a deck form
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
    @deck_string_info = @deck_strings.where(language: params[:language]).first
    @languages = Languages.list
    @deck_string = DeckString.new
    @collection = Collection.new
    @collection_string = CollectionString.new
    @collection.user = @user # enable view's evaluation of collection policy create?
    @collection_string.user = @user
    # prepare simple_field usage
    @collection.collection_strings.build
    # TODO: may require a joins to eliminate archived deck data
    @collections_owned = policy_scope(Collection).collections_owned(@user)
    collections_owned_strings = {
      objects: @collections_owned, user: @user, string_type: 'collection_strings', id_type: :collection_id, permission_type: nil, deck: 'deck'
    }
    @collections_owned_strings = PopulateStrings.new(collections_owned_strings).call

    # list of collections the user can read but does not own
    @collections_read = policy_scope(Collection).collections_not_owned(@user, false)

    collection_read_strings = {
      objects: @collections_read, user: @user, string_type: 'collection_strings', id_type: :collection_id, permission_type: 'collection_permissions', deck: 'deck'
    }
    @collections_read_strings = PopulateStrings.new(collection_read_strings).call

    # list of collections the user can read & update but does not own
    @collections_update = policy_scope(Collection).collections_not_owned(@user, true)

    collection_update_strings = {
      objects: @collections_update, user: @user, string_type: 'collection_strings', id_type: :collection_id, permission_type: 'collection_permissions', deck: 'deck'
    }
    @collections_update_strings = PopulateStrings.new(collection_update_strings).call

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

    @categories = Category.all

    @deck.user = @user
    @deck.deck_strings.first.user = @user
    @deck.collections.first.user = @user
    @deck.collections.first.collection_strings.first.user = @user
    # @deck.collections.first.collection_strings.first.user
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
      redirect_to deck_path(@deck, language: @deck.default_language)
    else
      redirect_to decks_path
    end

  end

  def update
    authorize(@deck)
    if @deck.update!(deck_params)
      redirect_to deck_path(@deck, language: params['deck']['language'])
    else
      redirect_to decks_path, flash[:alert] = "Unable to update"
    end
  end

  private

  def deck_params
    params.require(:deck).permit(
      :category_id,
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
