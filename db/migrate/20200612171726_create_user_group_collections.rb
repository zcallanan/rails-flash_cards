class CreateUserGroupCollections < ActiveRecord::Migration[6.0]
  def change
    create_table :user_group_collections do |t|
      t.references :user_group, null: false, foreign_key: true
      t.references :collection, null: false, foreign_key: true

      t.timestamps
    end
  end
end
