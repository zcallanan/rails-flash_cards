class CreateTagSetStrings < ActiveRecord::Migration[6.0]
  def change
    create_table :tag_set_strings do |t|
      t.string :title
      t.references :tag_set, null: false, foreign_key: true

      t.timestamps
    end
  end
end
