class TagSetPermission < ApplicationRecord
  belongs_to :tag_set
  belongs_to :user
  belongs_to :tag_set_string
end
