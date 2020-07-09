class Card < ApplicationRecord
  belongs_to :deck
  belongs_to :user
  has_many :collection_cards
  has_many :collections, through: :collection_cards
  has_many :tag_relations
  has_many :tags, through: :tag_relations
  has_many :answers
  has_many :card_question_sets
  has_many :questions, through: :card_question_sets
end
