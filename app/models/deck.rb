class Deck < ApplicationRecord
  attr_accessor :language

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

  scope :my_decks_owned, lambda { |user, archived|
    where(user: user, archived: archived)
  }

  scope :my_decks_not_owned, lambda { |user, update|
    includes(:deck_permissions).where('deck_permissions.user_id = ? AND deck_permissions.read_access = ? AND deck_permissions.update_access = ?', user.id, true, update).where.not(user: user).references(:deck_permissions).distinct
  }

  scope :globally_available, lambda { |bool|
    where(global_deck_read: bool, archived: false)
  }

  def owner
    user
  end

  # def collaborators
  #   users
  # end
end
