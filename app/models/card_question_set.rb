class CardQuestionSet < ApplicationRecord
  belongs_to :question_set
  belongs_to :card
  belongs_to :question
end
