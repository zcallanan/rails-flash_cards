class QuestionString < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :user_logs

  validates :language, :question, :field_type, presence: true
end
