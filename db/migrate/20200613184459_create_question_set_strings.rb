class CreateQuestionSetStrings < ActiveRecord::Migration[6.0]
  def change
    create_table :question_set_strings do |t|
      t.string :language
      t.string :title
      t.string :description
      t.references :question_set, null: false, foreign_key: true

      t.timestamps
    end
  end
end
