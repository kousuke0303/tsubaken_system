class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :status
      t.string :before_status
      t.datetime :moved_on
      t.integer :row_order
      t.text :memo
      t.string :default_title
      t.integer :count
      t.datetime :limited_on
      t.boolean :notification, default: false
      t.timestamps
    end
  end
end
