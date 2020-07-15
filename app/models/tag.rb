class Tag < ApplicationRecord
  has_many :tag_relations
  has_many :cards, through: :tag_relations
  has_many :user_logs

  validates :name, presence: true, length: { minimum: 3, maximum: 35 }

  def self.collect_tags(deck)
    Tag.all.includes(tag_relations: :card).where(cards: { deck_id: deck.id }).references(tag_relations: :cards)
  end
end
