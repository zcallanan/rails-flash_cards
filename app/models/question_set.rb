class QuestionSet < ApplicationRecord
  belongs_to :deck
  belongs_to :user
  has_many :card_question_sets
  has_many :questions, through: :card_question_sets
  has_many :cards, through: :card_question_sets
  has_many :question_set_strings
end
