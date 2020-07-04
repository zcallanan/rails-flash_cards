class TagSetString < ApplicationRecord
  belongs_to :tag_set
  belongs_to :user

  validates :title, :language, presence: true
end
