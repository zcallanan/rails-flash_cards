class QuestionSetString < ApplicationRecord
  belongs_to :question_set
  belongs_to :user

  validates :language, :title, presence: true
end
