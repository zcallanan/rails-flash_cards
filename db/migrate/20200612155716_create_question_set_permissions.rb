class CreateQuestionSetPermissions < ActiveRecord::Migration[6.0]
  def change
    create_table :question_set_permissions do |t|
      t.string :language
      t.boolean :read_access
      t.boolean :update_access
      t.boolean :clone_access
      t.references :user, null: false, foreign_key: true
      t.references :question_set, null: false, foreign_key: true

      t.timestamps
    end
  end
end
