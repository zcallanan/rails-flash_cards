class CollectionCard < ApplicationRecord
  belongs_to :card
  belongs_to :collection
end
