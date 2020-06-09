class CreateCollectionCards < ActiveRecord::Migration[6.0]
  def change
    create_table :collection_cards do |t|
      t.integer :priority
      t.integer :view_count, default: 0
      t.references :card, null: false, foreign_key: true
      t.references :collection, null: false, foreign_key: true

      t.timestamps
    end
  end
end
