class CollectionString < ApplicationRecord
  belongs_to :collection
  has_many :collection_permissions

  validates :collection, :language, :title, presence: true
end
