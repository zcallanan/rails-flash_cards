class DeckString < ApplicationRecord
  belongs_to :deck

  validates :language, :title, presence: true, uniqueness: true
end
