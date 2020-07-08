class CreateTagRelations < ActiveRecord::Migration[6.0]
  def change
    create_table :tag_relations do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :card, null: false, foreign_key: true

      t.timestamps
    end
  end
end
