class AddReferencesToMemberCodes < ActiveRecord::Migration[5.2]
  def change
    add_reference :member_codes, :supplier_manager, foreign_key: true
  end
end
