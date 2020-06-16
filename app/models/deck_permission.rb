class DeckPermission < ApplicationRecord
  belongs_to :deck
  belongs_to :user
  belongs_to :deck_string
end
