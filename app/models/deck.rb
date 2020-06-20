class Deck < ApplicationRecord
  belongs_to :user
  has_many :deck_permissions
  has_many :users, through: :deck_permissions
  has_many :question_sets
  has_many :card_question_sets, through: :question_sets
  has_many :deck_strings, inverse_of: :deck
  has_many :collections
  has_many :cards
  has_many :deck_categories
  has_many :categories, through: :deck_categories
  accepts_nested_attributes_for :deck_strings, :collections

  def owner
    user
  end

  # def collaborators
  #   users
  # end
end
