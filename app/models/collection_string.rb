class CollectionString < ApplicationRecord
  belongs_to :collection
  has_many :collection_permissions

  validates :language, :title, presence: true
end
