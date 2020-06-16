class DeckString < ApplicationRecord
  belongs_to :deck
  has_many :deck_permissions
  accepts_nested_attributes_for :deck

  validates :language, :title, presence: true
end
