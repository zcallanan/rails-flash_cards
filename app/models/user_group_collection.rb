class UserGroupCollection < ApplicationRecord
  belongs_to :user_group
  belongs_to :collection
end
