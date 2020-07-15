class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :static, default: false

      t.timestamps
    end
  end
end
