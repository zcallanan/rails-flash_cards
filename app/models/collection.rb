class Collection < ApplicationRecord
  belongs_to :deck
  belongs_to :user
  has_many :collection_cards
  has_many :cards, through: :collection_cards
  has_many :collection_tags
  has_many :tags, through: :collection_tags
  has_many :collection_permissions
  has_many :users, through: :collection_permissions
  has_many :collection_strings, inverse_of: :collection
  accepts_nested_attributes_for :collection_strings
end
