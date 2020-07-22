class Category < ApplicationRecord
  attr_accessor :language, :tag, :title

  has_many :decks

  # category select method for search
  def self.generate_categories(val = nil)
    themes = Category.pluck(:theme).sort.uniq
    themes -= ['All'] if val == 'no_all'

    themes.map do |theme|
      [theme, Category.where(theme: theme).map do |category|
        [category.name, category.id]
      end]
    end
  end

  def self.disabled_all
    themes = Category.pluck(:theme).sort.uniq

    themes.map do |theme|
      [theme, Category.where(theme: theme).map do |category|
        if theme == 'All'
          { value: category.id, label: category.name, disabled: true }
        else
          { value: category.id.to_s, label: category.name }
        end
      end]
    end
  end

  def self.enabled_all
    themes = Category.pluck(:theme).sort.uniq

    themes.map do |theme|
      [theme, Category.where(theme: theme).map do |category|
        { value: category.id.to_s, label: category.name }
      end]
    end
  end
end
