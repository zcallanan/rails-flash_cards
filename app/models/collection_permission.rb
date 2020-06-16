class CollectionPermission < ApplicationRecord
  belongs_to :collection
  belongs_to :user
  belongs_to :collection_string
end
