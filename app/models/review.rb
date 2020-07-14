class Review < ApplicationRecord
  belongs_to :user
  belongs_to :deck

  validates :rating, numericality: true, presence: true
end
