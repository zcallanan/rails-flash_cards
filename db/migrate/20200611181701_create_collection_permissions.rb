class CreateCollectionPermissions < ActiveRecord::Migration[6.0]
  def change
    create_table :collection_permissions do |t|
      t.boolean :read_access
      t.boolean :update_access
      t.boolean :clone_access
      t.references :user, null: false, foreign_key: true
      t.references :collection, null: false, foreign_key: true

      t.timestamps
    end
  end
end
