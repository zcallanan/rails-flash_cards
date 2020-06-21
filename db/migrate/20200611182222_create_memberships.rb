class CreateMemberships < ActiveRecord::Migration[6.0]
  def change
    create_table :memberships do |t|
      t.string :user_label
      t.boolean :confirmed, default: false
      t.boolean :read_access, default: false
      t.boolean :update_access, default: false
      t.references :user, foreign_key: true
      t.references :user_group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
