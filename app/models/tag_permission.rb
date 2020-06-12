class TagPermission < ApplicationRecord
  belongs_to :user
  belongs_to :tag_set
end
