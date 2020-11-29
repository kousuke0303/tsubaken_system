class CreateKinds < ActiveRecord::Migration[5.2]
  def change
    create_table :kinds do |t|
      t.string :title
      t.string :amount
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
