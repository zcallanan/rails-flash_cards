class QuestionSet < ApplicationRecord
  belongs_to :deck
  has_many :card_question_sets
  has_many :questions, through: :card_question_sets
  has_many :cards, through: :card_question_sets
end
