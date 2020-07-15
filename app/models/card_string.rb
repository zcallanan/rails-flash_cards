class CardString < ApplicationRecord
  belongs_to :card
  belongs_to :user
  has_many :user_logs

  validates :language, :title, presence: true
end
