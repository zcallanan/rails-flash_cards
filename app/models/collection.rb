class Collection < ApplicationRecord
  belongs_to :deck
  belongs_to :user
  has_many :collection_cards
  has_many :cards, through: :collection_cards
  has_many :collection_tags
  has_many :tags, through: :collection_tags
  has_many :collection_strings, inverse_of: :collection
  accepts_nested_attributes_for :collection_strings

  scope :collections_owned, lambda { |user|
    where(user: user)
  }

  scope :collections_not_owned, lambda { |user, update|
    includes(deck: :deck_permissions).where('deck_permissions.user_id = ? AND deck_permissions.read_access = ? AND deck_permissions.update_access = ?', user.id, true, update).where.not(user: user).references(decks: :deck_permissions).distinct
  }
end
