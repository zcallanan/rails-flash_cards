class CollectionCard < ApplicationRecord
  belongs_to :card
  belongs_to :collection
  has_many :user_logs
end
