class Category < ApplicationRecord
  attr_accessor :language

  has_many :decks

  # category select method for search
  def self.generate_categories
    categories = []
    themes = Category.pluck(:theme).sort.uniq
    themes.each do |theme|
      categories << [theme, Category.where(theme: theme)]
    end
    categories
  end
end
