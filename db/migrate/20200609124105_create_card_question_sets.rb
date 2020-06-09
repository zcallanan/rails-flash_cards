class CreateCardQuestionSets < ActiveRecord::Migration[6.0]
  def change
    create_table :card_question_sets do |t|
      t.references :question_set, null: false, foreign_key: true
      t.references :card, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
