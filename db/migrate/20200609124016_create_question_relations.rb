class CreateQuestionRelations < ActiveRecord::Migration[6.0]
  def change
    create_table :question_relations do |t|
      t.references :deck, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.references :card, null: false, foreign_key: true

      t.timestamps
    end
  end
end
