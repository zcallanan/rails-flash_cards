class DeckString < ApplicationRecord
  belongs_to :deck

  validates :language, :title, presence: true
  # validates :title, uniqueness: true
end
