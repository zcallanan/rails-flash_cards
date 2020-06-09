class Tag < ApplicationRecord
  has_many :card_tags
  has_many :cards, through: :card_tags
  has_many :collection_tags
  has_many :tags, through: :collection_tags
end
