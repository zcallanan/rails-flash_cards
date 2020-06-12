class CreateTagPermissions < ActiveRecord::Migration[6.0]
  def change
    create_table :tag_permissions do |t|
      t.boolean :read_access
      t.boolean :write_access
      t.references :user, null: false, foreign_key: true
      t.references :tag_set, null: false, foreign_key: true

      t.timestamps
    end
  end
end
