class CreateCovers < ActiveRecord::Migration[5.2]
  def change
    create_table :covers do |t|
      t.string :title,           default: false
      t.string :content
      t.boolean :default,        default: false
      t.integer :image_id
      t.string :estimate_matter_id
      t.string :publisher_id

      t.timestamps
    end
      add_index  :covers, :estimate_matter_id
      add_index  :covers, :image_id
      add_index  :covers, :publisher_id
  end
end
