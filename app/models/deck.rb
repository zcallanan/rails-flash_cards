class Deck < ApplicationRecord
  belongs_to :user
  has_many :deck_permissions
  has_many :users, through: :deck_permissions
  has_many :question_sets
  has_many :card_question_sets, through: :question_sets
  has_many :deck_strings
  accepts_nested_attributes_for :deck_strings

  scope :deck_access, ->(user) { includes(:deck_permissions).where(where({ deck_permissions: { user_id: user.id, read_access: true } }, global_deck_read: true, user_id: user.id).where_values_hash.reduce(&:or)) }

  def owner
    user
  end

  # def collaborators
  #   users
  # end
end
