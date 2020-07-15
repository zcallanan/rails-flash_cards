class Question < ApplicationRecord
  belongs_to :user
  has_many :question_strings
  has_many :answers
  has_many :question_relations
  has_many :user_logs
end
