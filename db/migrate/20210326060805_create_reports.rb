class CreateReports < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.string :title,           null: false
      t.string :content
      t.integer :position
      t.boolean :default,        default: false
      t.integer :image_id
      t.integer :message_id
      t.string :matter_id
      t.date :created_on

      t.timestamps
    end
    add_foreign_key :reports, :matters
    add_index  :reports, :matter_id
  end
end
