class DeckString < ApplicationRecord
  belongs_to :deck
  belongs_to :user
  accepts_nested_attributes_for :deck

  validates :deck, :language, :title, presence: true
end
