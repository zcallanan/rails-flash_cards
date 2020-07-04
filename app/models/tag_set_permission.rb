class TagSetPermission < ApplicationRecord
  belongs_to :tag_set
  belongs_to :user
end
