class CreateDeckCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :deck_categories do |t|
      t.references :category, null: false, foreign_key: true
      t.references :deck, null: false, foreign_key: true

      t.timestamps
    end
  end
end
