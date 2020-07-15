class CollectionString < ApplicationRecord
  belongs_to :collection
  belongs_to :user
  has_many :user_logs

  validates :collection, :language, :title, presence: true
  validates :title, length: { minimum: 3, maximum: 256 }
  validates :description, length: { minimum: 3 }
end
