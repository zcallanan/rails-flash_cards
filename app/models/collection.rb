class Collection < ApplicationRecord
  belongs_to :deck
  has_many :collection_cards
  has_many :cards, through: :collection_cards
  has_many :collection_tags
  has_many :tags, through: :collection_tags
end
