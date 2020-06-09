class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :card
  belongs_to :question
end
