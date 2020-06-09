class CreateQuestionStrings < ActiveRecord::Migration[6.0]
  def change
    create_table :question_strings do |t|
      t.string :language
      t.string :question
      t.integer :field_type, default: 0
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
