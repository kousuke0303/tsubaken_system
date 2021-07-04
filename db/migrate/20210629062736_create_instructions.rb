class CreateInstructions < ActiveRecord::Migration[5.2]
  def change
    create_table :instructions do |t|
      t.text :title,         null: false, default: ""
      t.text :content
      t.boolean :default
      t.integer :position
      t.string :estimate_matter_id

      t.timestamps
    end
    add_index  :instructions, :estimate_matter_id
  end
end
