class CollectionStringsController < ApplicationController
  before_action :set_deck, only: %i[create update]
  before_action :set_collection, only: %i[create update]
  before_action :set_collection_string, only: %i[update]

  def create
    @collection_string = CollectionString.new(collection_string_params)
    @collection_string.user = current_user
    @collection_string.collection = @collection
    authorize(@collection_string)
    if @collection_string.save!
      redirect_to deck_path(@deck)
    else
      redirect_to decks_path
    end
  end

  def update
    @user = current_user
    authorize @collection_string
    if @collection_string.update!(collection_string_params)
      redirect_to deck_collection_path(@deck, @collection)
    else
      redirect_to decks_path
    end
  end

  private

  def collection_string_params
    params.require(:collection_string).permit(:title, :description, :language)
  end

  def set_deck
    @deck = Deck.find(params[:deck_id])
  end

  def set_collection
    @collection = Collection.find(params[:collection_id])
  end

  def set_collection_string
    @collection_string = CollectionString.find(params[:id])
  end
end
