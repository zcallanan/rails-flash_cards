class UserGroupTagSet < ApplicationRecord
  belongs_to :user_group
  belongs_to :tag_set
end
