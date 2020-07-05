class CollectionsController < ApplicationController
  before_action :set_deck, only: %i[show create]
  before_action :set_collection, only: %i[show]
  def show
    @user = current_user
    @collection_string = @collection.collection_strings.first
    authorize @collection
  end

  def create
    @user = current_user
    @collection = Collection.new(collection_params)
    @collection.user = @user
    @collection.deck = @deck
    @collection.collection_strings.first.user = @user
    authorize @collection
    if @collection.save!
      redirect_to deck_collection_path(@deck, @collection)
    else
      redirect_to deck_path(@deck)
    end
  end

  private

  def collection_params
    params.require(:collection).permit(collection_strings_attributes: [:language, :title, :description])
  end

  def set_deck
    @deck = Deck.find(params[:deck_id])
  end

  def set_collection
    @collection = Collection.find(params[:id])
  end
end
