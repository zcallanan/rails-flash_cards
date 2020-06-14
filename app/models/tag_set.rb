class TagSet < ApplicationRecord
  belongs_to :user
  has_many :tag_set_strings
end
