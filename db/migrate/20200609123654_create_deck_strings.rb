class CreateDeckStrings < ActiveRecord::Migration[6.0]
  def change
    create_table :deck_strings do |t|
      t.string :language
      t.string :title
      t.string :description
      t.references :user, null: false, foreign_key: true
      t.references :deck, null: false, foreign_key: true

      t.timestamps
    end
  end
end
