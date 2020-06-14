class TagSetString < ApplicationRecord
  belongs_to :tag_set

  validates :title, :language, presence: true
end
