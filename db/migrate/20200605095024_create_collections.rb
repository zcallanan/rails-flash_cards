class CreateCollections < ActiveRecord::Migration[6.0]
  def change
    create_table :collections do |t|
      t.references :deck, null: false, foreign_key: true

      t.timestamps
    end
  end
end
