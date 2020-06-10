class Deck < ApplicationRecord
  belongs_to :user
  has_many :deck_permissions
  has_many :users, through: :deck_permissions
  has_many :question_sets
  has_many :card_question_sets, through: :question_sets

  def owner
    user
  end

  def collaborators
    users
  end
end
