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
    if Category.find(categories).first.name == 'All Categories'
      where(global_deck_read: true)
    else
      category_hash = {}
      categories.each { |category_id| category_hash[:category_id] = category_id }
      category_hash[:global_deck_read] = true
      where(category_hash)
    end
  }

  scope :mydecks_search_by_categories, lambda { |categories, user, archived|
    if Category.find(categories).first.name == 'All Categories'
      where(user: user, archived: archived)
    else
      category_hash = {}
      categories.each { |category_id| category_hash[:category_id] = category_id }
      category_hash[:user] = user
      category_hash[:archived] = archived
      where(category_hash)
    end
  }

  scope :shared_search_by_categories, lambda { |categories, user, update|
    if Category.find(categories).first.name == 'All Categories'
      includes(:deck_permissions).where(deck_permissions: { user_id: user.id, read_access: true, update_access: update }).where.not(user: user).references(:deck_permissions).distinct
    else
      category_hash = {}
      categories.each { |category_id| category_hash[:category_id] = category_id }
      category_hash[:user] = user
      category_hash[:read_access] = true
      category_hash[:update_access] = update
      includes(:deck_permissions).where(category_hash).where.not(user: user).references(:deck_permissions).distinct
    end
  }

  scope :search_by_language, lambda { |language|
    includes(:deck_strings).where('deck_strings.language = ?', language).references(:deck_strings)
  }

  scope :search_by_tags, lambda { |tags|
    tag_array = tags.split(',')
    tag_hash = {}
    tag_array.each { |tag| tag_hash[:tags] = { name: tag } }
    includes(cards: [tag_relations: :tag]).where(tag_hash).references(cards: [tag_relations: :tags])
  }

  scope :my_decks_owned, lambda { |user, archived|
    where(user: user, archived: archived)
  }

  def owner
    user
  end
end
