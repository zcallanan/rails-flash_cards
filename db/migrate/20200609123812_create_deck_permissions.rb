class CreateDeckPermissions < ActiveRecord::Migration[6.0]
  def change
    create_table :deck_permissions do |t|
      t.integer :access_level, default: 0
      t.boolean :creator, default: false
      t.references :deck, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
