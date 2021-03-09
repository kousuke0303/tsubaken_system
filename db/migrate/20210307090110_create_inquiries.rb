class CreateInquiries < ActiveRecord::Migration[5.2]
  def change
    create_table :inquiries do |t|
      t.integer :kind,         null: false
      t.string :name
      t.string :kana
      t.string :email
      t.string :phone
      t.string :reply_email
      t.datetime :solved_at

      t.timestamps
    end
  end
end
