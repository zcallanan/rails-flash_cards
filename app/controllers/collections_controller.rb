class CollectionsController < ApplicationController
  before_action :set_deck, only: %i[show]
  before_action :set_collection, only: %i[show]
  def show
    authorize @collection
  end

  def create
    @collection = Collection.new(collection_params)
    authorize @collection
    # prepare simple_field usage
    @collection.collection_strings.build
  end

  private

  def collection_params
    params.require(:collection).permit(:collection_id, :deck_id, :language, :title, :description)
  end

  def set_deck
    @deck = Deck.find(params[:deck_id])
  end

  def set_collection
    @collection = Collection.find(params[:id])
  end
end
