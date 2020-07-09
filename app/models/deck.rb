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

  scope :global_search_by_categories, lambda { |categories|
    if categories.size == 1 && categories.first.empty?
      where(global_deck_read: true)
    else
      category_hash = {}
      categories.each { |category_id| category_hash[:category_id] = category_id }
      category_hash[:global_deck_read] = true
      where(category_hash)
    end
  }

  scope :global_search_by_language, lambda { |language|
    includes(:deck_strings).where('deck_strings.language = ?', language).references(:deck_strings)
  }

  scope :global_search_by_tags, lambda { |tags|
    tag_array = tags.split(',')
    tag_hash = {}
    tag_array.each { |tag| tag_hash[:tags] = { name: tag } }
    includes(cards: [tag_relations: :tag]).where(tag_hash).references(cards: [tag_relations: :tags])
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
