class DeckCategory < ApplicationRecord
  belongs_to :category
  belongs_to :deck
end
