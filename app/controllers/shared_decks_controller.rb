class SharedDecksController < ApplicationController
  def index
    @user = current_user
    # list of decks that are globally available
    @decks_global = policy_scope(Deck).where(global_deck_read: true, archived: false)
    deck_strings = {
      objects: @decks_global,
      user: @user,
      string_type: 'deck_strings',
      id_type: :deck_id,
      permission_type: nil,
      deck: nil
    }
    # app/controllers/concerns/populate_strings
    @decks_global_strings = PopulateStrings.new(deck_strings).call
  end
end
