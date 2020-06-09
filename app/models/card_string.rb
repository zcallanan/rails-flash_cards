class CardString < ApplicationRecord
  belongs_to :card

  validates :language, :title, presence: true
end
