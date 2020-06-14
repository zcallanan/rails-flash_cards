class TagSetString < ApplicationRecord
  belongs_to :tag_set

  validates :title, presence: true, uniqueness: true
end
