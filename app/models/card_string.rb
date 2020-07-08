class CardString < ApplicationRecord
  belongs_to :card
  belongs_to :user

  validates :language, :title, presence: true
end
