class Collection < ApplicationRecord

  belongs_to :deck
  belongs_to :user
  has_many :collection_cards
  has_many :cards, through: :collection_cards
  has_many :collection_tags
  has_many :tags, through: :collection_tags
  has_many :collection_strings, inverse_of: :collection
  has_many :user_logs
  accepts_nested_attributes_for :collection_strings

  scope :all_cards, lambda { |deck|
    includes(:collection_strings).where(deck: deck, collection_strings: { title: 'All Cards' }).references(:collection_strings)
  }

  scope :collections_owned, lambda { |user, deck|
    includes(:collection_strings).where(user: user, deck: deck).where.not(collection_strings: { title: 'All Cards' }).references(:collection_strings)
  }

  scope :collections_shared, lambda { |user, deck|
    includes(deck: :deck_permissions).where(deck_id: deck.id, deck_permissions: { user_id: user.id, read_access: true }).where.not(user: user).references(decks: :deck_permissions).distinct
  }

  scope :collections_not_owned, lambda { |user, update|
    includes(deck: :deck_permissions).where('deck_permissions.user_id = ? AND deck_permissions.read_access = ? AND deck_permissions.update_access = ?', user.id, true, update).where.not(user: user).references(decks: :deck_permissions).distinct
  }
end
