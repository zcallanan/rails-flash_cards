class CreateUserGroupDecks < ActiveRecord::Migration[6.0]
  def change
    create_table :user_group_decks do |t|
      t.references :user_group, null: false, foreign_key: true
      t.references :deck, null: false, foreign_key: true

      t.timestamps
    end
  end
end
