class QuestionString < ApplicationRecord
  belongs_to :question

  validates :language, :question, :field_type, presence: true
  # validates :question, uniqueness: true
end
