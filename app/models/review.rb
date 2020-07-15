class Review < ApplicationRecord
  belongs_to :user
  belongs_to :deck

  validates :title, presence: true, length: { minimum: 3, maximum: 256 }
  validates :body, presence: true, length: { minimum: 3 }
  validates :rating, numericality: { only_integer: true }, presence: true
end
