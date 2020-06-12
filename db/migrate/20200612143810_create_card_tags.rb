class CreateCardTags < ActiveRecord::Migration[6.0]
  def change
    create_table :card_tags do |t|
      t.references :tag_set, null: false, foreign_key: true
      t.references :card, null: false, foreign_key: true

      t.timestamps
    end
  end
end
