class TagSet < ApplicationRecord
  belongs_to :user
  belongs_to :deck
  has_many :tag_set_strings
end
