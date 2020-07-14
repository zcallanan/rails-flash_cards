class CollectionString < ApplicationRecord
  belongs_to :collection
  belongs_to :user
  has_many :user_logs

  validates :collection, :language, :title, presence: true
end
