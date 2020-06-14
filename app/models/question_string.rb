class QuestionString < ApplicationRecord
  belongs_to :question

  validates :language, :question, :field_type, presence: true, uniqueness: true
end
