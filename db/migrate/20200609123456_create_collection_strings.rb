class CreateCollectionStrings < ActiveRecord::Migration[6.0]
  def change
    create_table :collection_strings do |t|
      t.string :language
      t.string :title
      t.string :description
      t.references :collection, null: false, foreign_key: true

      t.timestamps
    end
  end
end
