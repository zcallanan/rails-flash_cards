class TagRelation < ApplicationRecord
  belongs_to :tag
  belongs_to :card
  has_many :user_logs
end
