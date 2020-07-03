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

  scope :collections_owned, lambda { |user|
    where(user: user)
  }

  scope :collections_not_owned, lambda { |user, update|
    includes(:collection_permissions).where('collection_permissions.user_id = ? AND collection_permissions.read_access = ? AND collection_permissions.update_access = ?', user.id, true, update).where.not(user: user).references(:collection_permissions).distinct
  }
end
