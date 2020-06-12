class CollectionTag < ApplicationRecord
  belongs_to :tag_set
  belongs_to :collection
end
