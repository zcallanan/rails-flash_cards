class Membership < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :user_group
end
