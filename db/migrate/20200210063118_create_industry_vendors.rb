class CreateIndustryVendors < ActiveRecord::Migration[5.2]
  def change
    create_table :industry_vendors do |t|
      t.references :industry, foreign_key: true
      t.references :vendor, foreign_key: true

      t.timestamps
    end
  end
end
