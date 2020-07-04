class CollectionString < ApplicationRecord
  belongs_to :collection
  belongs_to :user

  validates :collection, :language, :title, presence: true
end
