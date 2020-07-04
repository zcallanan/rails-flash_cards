class CreateCollectionPermissions < ActiveRecord::Migration[6.0]
  def change
    create_table :collection_permissions do |t|
      t.boolean :read_access, default: false
      t.boolean :update_access, default: false
      t.boolean :clone_access, default: false
      t.references :user, null: false, foreign_key: true
      t.references :collection, null: false, foreign_key: true

      t.timestamps
    end
  end
end
