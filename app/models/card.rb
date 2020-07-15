class Card < ApplicationRecord
  belongs_to :deck
  belongs_to :user
  has_many :collection_cards
  has_many :collections, through: :collection_cards
  has_many :tag_relations
  has_many :tags, through: :tag_relations
  has_many :answers
  has_many :question_relations
  has_many :questions, through: :question_relations
  has_many :user_logs

  scope :total_cards, lambda { |deck|
    where(deck: deck)
  }
end
