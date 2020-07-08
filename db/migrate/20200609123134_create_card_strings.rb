class CreateCardStrings < ActiveRecord::Migration[6.0]
  def change
    create_table :card_strings do |t|
      t.string :language
      t.string :title
      t.string :body
      t.references :card, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
