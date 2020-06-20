class TagSetString < ApplicationRecord
  belongs_to :tag_set
  belongs_to :user
  has_many :tag_set_permissions

  validates :title, :language, presence: true
end
