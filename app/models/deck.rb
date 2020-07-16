class Deck < ApplicationRecord
  attr_accessor :language, :collect

  belongs_to :user
  belongs_to :category
  has_many :deck_permissions
  has_many :users, through: :deck_permissions
  has_many :question_relations
  has_many :questions, through: :question_relations
  has_many :deck_strings, inverse_of: :deck
  has_many :collections
  has_many :cards
  has_many :user_logs
  has_many :ratings
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
    tag_hash = {}
    tags.each { |tag| tag_hash[:tags] = { id: tag } }
    includes(cards: [tag_relations: :tag]).where(tag_hash).references(cards: [tag_relations: :tags])
  }

  scope :my_decks_owned, lambda { |user, archived|
    where(user: user, archived: archived)
  }

  def owner
    user
  end

  def self.collection_select(user, all_cards, collections_owned, collections_shared)
    types = {
      'All' => '',
      'Custom Card Collections' => '',
      'Shared Card Collections' => ''
    }

    collections_hash = {
      objects: '', user: user, string_type: 'collection_strings', id_type: :collection_id, deck: 'deck'
    }

    array = []

    types.each do |key, value|
      if key == 'All'
        collections = all_cards
      elsif key == 'Custom Card Collections'
        collections = collections_owned
      elsif key == 'Shared Card Collections'
        collections = collections_shared
      end
      collections_hash[:objects] = collections

      value = PopulateStrings.new(collections_hash).call unless collections.nil?

      result = [key, value.map do |collection_string| [collection_string.title, collection_string.collection.id, { data: { target: 'collection-select.option', action: 'click->collection-select#collectionContent' } }] end]
      array << result unless result[1].empty?
    end
    array
  end
end
