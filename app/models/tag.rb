class Tag < ApplicationRecord
  has_many :tag_relations
  has_many :cards, through: :tag_relations
  has_many :user_logs

  validates :name, presence: true, length: { minimum: 3, maximum: 35 }

  def self.collect_tags(deck)
    Tag.all.includes(tag_relations: :card).where(cards: { deck_id: deck.id }).references(tag_relations: :cards)
  end

  def self.search_select
    # builds the array used by search to suggest tags
    tags = Tag.all
    array = []
    tags.each do |tag|
      array << [tag.name, tag.id]
    end
    array
  end
end
