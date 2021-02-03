class CreateLabelColors < ActiveRecord::Migration[5.2]
  def change
    create_table :label_colors do |t|
      t.string :name,        null: false, unique: true
      t.string :color_code,  null: false, unique: true
      t.string :note

      t.timestamps
    end
  end
end
