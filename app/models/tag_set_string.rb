class TagSetString < ApplicationRecord
  belongs_to :tag_set

  validates :title, :language, presence: true
  # validates :title, uniqueness: true
end
