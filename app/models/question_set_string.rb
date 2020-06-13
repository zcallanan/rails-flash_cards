class QuestionSetString < ApplicationRecord
  belongs_to :question_set

  validates :language, :title, presence: true
end
