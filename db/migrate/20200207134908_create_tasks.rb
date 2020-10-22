class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.integer :status
      t.integer :before_status
      t.datetime :moved_at
      t.integer :row_order
      t.string :content
      t.integer :count
      t.date :limited_on
      t.integer :priority
      t.boolean :notification, default: false
      t.references :matter, foreign_key: true

      t.timestamps
    end
  end
end
