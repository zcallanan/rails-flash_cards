class Api::V1::DecksController < Api::V1::BaseController
  before_action :authenticate_user!, except: %i[global]
  acts_as_token_authentication_handler_for User, except: %i[global]
  before_action :set_deck, only: %i[update]

  def global
    array = global_decks

    render json: { data: { partials: array, formats: [:json], layout: false } }
  end

  def update
    authorize(@deck)
    if @deck.update!(deck_params)
      render json: @deck
    else
      render_error
    end
  end

  private

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

  def render_error
    render json: { errors: @membership.errors.full_messages },
      status: :unprocessable_entity
  end

  def deck_search(language, category_ids, tags)
    DeckSearchService.new(
      language: language,
      categories: category_ids,
      tags: tags
    ).call(true)
  end

  def global_decks
    # list of decks that are globally available
    # curl -s http://localhost:3000/api/v1/decks/global
    @decks_global = Deck.globally_available(true)
    if params.key?('category')
      language = params['category']['language']
      category_ids = params['category']['name']
      tags = params['category']['tag']
    else # account for going straight to /shared_decks
      language = 'en'
      category = Category.find_by(name: 'All Categories')
      category_ids = [category.id]
    end

    @decks = deck_search(language, category_ids, tags).order(updated_at: :desc)

    deck_strings = {
      objects: @decks,
      string_type: 'deck_strings',
      id_type: :deck_id,
      permission_type: nil,
      deck: nil,
      language: language
    }

    # app/controllers/concerns/populate_strings
    @decks_global_strings = PopulateStrings.new(deck_strings).call
    array = []
    @decks_global_strings.each do |string|
      array << render_to_string(
        partial: 'deck_panel',
        locals: { deck_string: string }
      )
    end
    array
  end
end
