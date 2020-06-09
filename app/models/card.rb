class Card < ApplicationRecord
  has_many :collection_cards
  has_many :collections, through: :collection_cards
  has_many :card_tags
  has_many :tags, through: :card_tags
end
