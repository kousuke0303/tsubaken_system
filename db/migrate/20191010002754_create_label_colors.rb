class CreateLabelColors < ActiveRecord::Migration[5.2]
  def change
    create_table :label_colors do |t|
      t.string :color_code,  null: false

      t.timestamps
    end
  end
end
