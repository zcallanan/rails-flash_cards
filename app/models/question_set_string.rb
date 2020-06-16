class QuestionSetString < ApplicationRecord
  belongs_to :question_set
  has_many :question_set_permissions

  validates :language, :title, presence: true
end
