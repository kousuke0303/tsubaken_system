class CreateQuotations < ActiveRecord::Migration[5.2]
  def change
    create_table :quotations do |t|
      t.references :client, foreign_key: true
      t.references :kind, foreign_key: true
      t.string :title
      t.string :amount

      t.timestamps
    end
  end
end
