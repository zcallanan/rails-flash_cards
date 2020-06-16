class QuestionSetPermission < ApplicationRecord
  belongs_to :user
  belongs_to :question_set
  belongs_to :question_set_string
end
