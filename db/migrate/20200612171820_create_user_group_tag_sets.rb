class CreateUserGroupTagSets < ActiveRecord::Migration[6.0]
  def change
    create_table :user_group_tag_sets do |t|
      t.references :user_group, null: false, foreign_key: true
      t.references :tag_set, null: false, foreign_key: true

      t.timestamps
    end
  end
end
