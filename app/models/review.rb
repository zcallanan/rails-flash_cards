class Review < ApplicationRecord
  belongs_to :user
  belongs_to :deck
  has_many :user_logs

  validates :title, presence: true, length: { minimum: 3, maximum: 256 }
  validates :body, presence: true, length: { minimum: 3 }
  validates :rating, numericality: { only_integer: true }, presence: true

  scope :generate_rating, lambda { |deck|
    where(deck: deck)
  }
end
