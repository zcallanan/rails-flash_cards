class UserGroupDeck < ApplicationRecord
  belongs_to :user_group
  belongs_to :deck
end
