class SupplierMatter < ApplicationRecord
  belongs_to :matter, inverse_of: :supplier_matters
  belongs_to :supplier
end
