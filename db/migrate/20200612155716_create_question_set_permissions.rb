class CreateQuestionSetPermissions < ActiveRecord::Migration[6.0]
  def change
    create_table :question_set_permissions do |t|
      t.string :language
      t.boolean :read_access, default: false
      t.boolean :update_access, default: false
      t.boolean :clone_access, default: false
      t.references :user, null: false, foreign_key: true
      t.references :question_set, null: false, foreign_key: true

      t.timestamps
    end
  end
end
