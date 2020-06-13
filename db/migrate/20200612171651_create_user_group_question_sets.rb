class CreateUserGroupQuestionSets < ActiveRecord::Migration[6.0]
  def change
    create_table :user_group_question_sets do |t|
      t.references :user_group, null: false, foreign_key: true
      t.references :question_set, null: false, foreign_key: true

      t.timestamps
    end
  end
end
