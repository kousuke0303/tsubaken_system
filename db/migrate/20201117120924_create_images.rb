class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|
      t.text :content
      t.date :shooted_on
      t.string :matter_id

      t.timestamps
    end
    add_foreign_key :images, :matters
    add_index  :images, :matter_id
  end
end
