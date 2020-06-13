class UserGroupQuestionSet < ApplicationRecord
  belongs_to :user_group
  belongs_to :question_set
end
