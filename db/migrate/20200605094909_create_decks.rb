class CreateDecks < ActiveRecord::Migration[6.0]
  def change
    create_table :decks do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :global_deck_read, default: false

      t.timestamps
    end
  end
end
