class CollectionString < ApplicationRecord
  belongs_to :collection
  belongs_to :user
  has_many :collection_permissions

  validates :collection, :language, :title, presence: true
end
