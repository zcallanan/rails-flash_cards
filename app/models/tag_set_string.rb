class TagSetString < ApplicationRecord
  belongs_to :tag_set
  has_many :tag_set_permissions

  validates :title, :language, presence: true
end
