class CreateDeckPermissions < ActiveRecord::Migration[6.0]
  def change
    create_table :deck_permissions do |t|
      t.boolean :read_access, default: false
      t.boolean :write_access, default: false
      t.boolean :clone_access, default: false
      t.references :deck, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
