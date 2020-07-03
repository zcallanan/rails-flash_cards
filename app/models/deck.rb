class Deck < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :deck_permissions
  has_many :users, through: :deck_permissions
  has_many :question_sets
  has_many :card_question_sets, through: :question_sets
  has_many :deck_strings, inverse_of: :deck
  has_many :collections
  has_many :cards
  accepts_nested_attributes_for :deck_strings, :collections

  scope :global_search_by_category, lambda { |category|
    category.empty? ? where(global_deck_read: true) : where(category_id: category, global_deck_read: true)
  }

  scope :global_search_by_language, lambda { |language|
    includes(:deck_strings).where('deck_strings.language = ?', language).references(:deck_strings)
  }

  def owner
    user
  end

  # def collaborators
  #   users
  # end
end
