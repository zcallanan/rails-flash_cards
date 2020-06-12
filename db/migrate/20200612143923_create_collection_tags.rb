class CreateCollectionTags < ActiveRecord::Migration[6.0]
  def change
    create_table :collection_tags do |t|
      t.references :tag_set, null: false, foreign_key: true
      t.references :collection, null: false, foreign_key: true

      t.timestamps
    end
  end
end
