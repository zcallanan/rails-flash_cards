class TagRelation < ApplicationRecord
  belongs_to :tag
  belongs_to :tag_set
end
