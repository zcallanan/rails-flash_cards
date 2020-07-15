class QuestionRelation < ApplicationRecord
  belongs_to :deck
  belongs_to :user
  belongs_to :question
  belongs_to :card
  has_many :user_logs
end
