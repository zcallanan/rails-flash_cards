class CreateUserLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :user_logs do |t|
      t.string :event
      t.references :user, null: false, foreign_key: true
      t.references :deck, foreign_key: true
      t.references :collection, foreign_key: true
      t.references :card, foreign_key: true
      t.references :collection_card, foreign_key: true
      t.references :tag_relation, foreign_key: true
      t.references :question_relation, foreign_key: true
      t.references :user_group, foreign_key: true
      t.references :deck_permission, foreign_key: true
      t.references :membership, foreign_key: true
      t.references :deck_string, foreign_key: true
      t.references :collection_string, foreign_key: true
      t.references :card_string, foreign_key: true
      t.references :tag, foreign_key: true
      t.references :review, foreign_key: true
      t.references :question, foreign_key: true
      t.references :answer, foreign_key: true
      t.references :question_string, foreign_key: true

      t.timestamps
    end
  end
end
