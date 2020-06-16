class DeckString < ApplicationRecord
  belongs_to :deck
  has_many :deck_permissions

  validates :language, :title, presence: true
end
