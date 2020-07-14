class Api::V1::CollectionsController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User
  before_action :set_deck, only: %i[collection_contents]

  def collection_contents

  end

  private

  def set_deck
    @deck = Deck.find(params[:deck_id])
  end

end
