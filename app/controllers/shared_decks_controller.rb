class SharedDecksController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    # All can view globally shared content
    skip_policy_scope
    # list of decks that are globally available
    @decks_global = Deck.where(global_deck_read: true, archived: false)
    deck_strings = {
      objects: @decks_global,
      string_type: 'deck_strings',
      id_type: :deck_id,
      permission_type: nil,
      deck: nil,
      language: params['category']['language']
    }

    # app/controllers/concerns/populate_strings
    @decks_global_strings = PopulateStrings.new(deck_strings).call
  end
end
