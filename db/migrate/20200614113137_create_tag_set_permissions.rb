class CreateTagSetPermissions < ActiveRecord::Migration[6.0]
  def change
    create_table :tag_set_permissions do |t|
      t.boolean :read_access, default: false
      t.boolean :update_access, default: false
      t.references :tag_set, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
