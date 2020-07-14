class DecksController < ApplicationController
  include Languages
  before_action :set_deck, only: %i[show update]

  def index
    if user_signed_in?
      @user = current_user

      # list of decks the user owns
      @decks_owned = policy_scope(Deck).my_decks_owned(@user, false) # used by decks_nav partial

      # create a deck form
      @deck = Deck.new
      # prepare simple_field usage
      @deck.deck_strings.build
      @collection = @deck.collections.build
      @collection_string = @collection.collection_strings.build
    else
      # All can view globally shared content
      skip_policy_scope
    end
    # search form
    @languages = Languages.list
    @category = Category.new
    @categories = Category.all
  end

  def show
    if user_signed_in?
      @user = current_user
      authorize @deck
      UserLog.create(user: @user, deck: @deck, event: 'Deck viewed')
      @deck_strings = @deck.deck_strings
      @deck_string_info = @deck_strings.where(language: params[:language]).first
      @languages = Languages.list
      # form setup
      @deck_string = DeckString.new
      @collection = Collection.new
      # enable view's evaluation of collection policy create?
      @collection.user = @user
      @collection.deck = @deck
      # prepare simple_field usage
      @collection.collection_strings.build

      @collections_owned = policy_scope(Collection).collections_owned(@user)
      collections_owned_strings = {
        objects: @collections_owned, user: @user, string_type: 'collection_strings', id_type: :collection_id, permission_type: nil, deck: 'deck'
      }
      @collections_owned_strings = PopulateStrings.new(collections_owned_strings).call

      # list of collections the user can read but does not own
      @collections_read = policy_scope(Collection).collections_not_owned(@user, false)

      collection_read_strings = {
        objects: @collections_read, user: @user, string_type: 'collection_strings', id_type: :collection_id, permission_type: 'deck_permissions', deck: 'deck'
      }
      @collections_read_strings = PopulateStrings.new(collection_read_strings).call

      # list of collections the user can read & update but does not own
      @collections_update = policy_scope(Collection).collections_not_owned(@user, true)

      collection_update_strings = {
        objects: @collections_update, user: @user, string_type: 'collection_strings', id_type: :collection_id, permission_type: 'deck_permissions', deck: 'deck'
      }
      @collections_update_strings = PopulateStrings.new(collection_update_strings).call

      @languages = Languages.list
      @language_options = [] # when updating a deck, user can change what language strings users see by default, if they exist. User preference overrides this
      @reduced_languages = {} # remove language options from language list if a string exists in that language
      language_collection = @deck.deck_strings.pluck(:language)
      @languages.each do |key, value|
        language_collection.include?(value) ? @language_options << [key, value] : @reduced_languages[key] = value
      end
    else
      # All can view globally shared content
      skip_authorization
      skip_policy_scope
      @deck_string = @deck.deck_strings.where(language: params[:language]).first
    end
  end

  def create
    @user = current_user
    @deck = Deck.new(deck_params)

    @categories = Category.all

    @deck.user = @user
    @deck.deck_strings.first.user = @user
    # @deck.collections.first.collection_strings.first.user
    authorize @deck
    if @deck.save!
      UserLog.create(user: @user, deck: @deck, event: 'Deck created')
      @deck.update!(default_language: @deck.deck_strings.first.language) # first string sets the default language
      # Set full access rights for deck owner
      DeckPermission.create!(deck: @deck, user: @user, read_access: true, update_access: true, clone_access: true)
      # Create the default collection. Collections are custom subsets of the full deck of cards used in review
      collection = Collection.create!(deck: @deck, user: @user, static: true)
      UserLog.create(user: @user, collection: collection, event: 'Collection created')
      # # Static: true - denotes the collection that should not allow its card content to be editable
      # Create strings for the initial collection
      # # TODO: localize these strings
      collection_string = CollectionString.create!(collection: collection, user: @user, language: @deck.default_language, title: 'All Cards', description: 'Review all cards in this deck.')
      UserLog.create(user: @user, collection_string: collection_string, collection: collection, event: 'Collection String created')

      redirect_to deck_path(@deck, language: @deck.default_language)
    else
      redirect_to decks_path
    end
  end

  def update
    authorize(@deck)
    if @deck.update!(deck_params)
      UserLog.create(user: @user, deck: @deck, event: 'Deck updated')
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
