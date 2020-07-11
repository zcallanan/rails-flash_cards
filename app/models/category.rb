class Category < ApplicationRecord
  attr_accessor :language, :tag

  has_many :decks

  # category select method for search
  def self.generate_categories(val = nil)
    themes = Category.pluck(:theme).sort.uniq
    themes -= ['All'] if val == 'no_all'

    themes.map do |theme|
      [theme, Category.where(theme: theme).map do |category|
        if theme == 'All'
          [category.name, category.id, { data: { target: 'category-select.all deck-tabs.option', action: 'click->category-select#options' } }]
        else
          [category.name, category.id, { data: { target: 'category-select.option deck-tabs.option', action: 'click->category-select#options' } }]
        end
      end]
    end
  end
end
