class AddColumnParentIdToMaterial < ActiveRecord::Migration[5.2]
  def change
    add_reference :materials, :parent, index: true, default: nil
    add_foreign_key :materials, :materials, column: :parent_id
  end
end
