class SupplierMatter < ApplicationRecord
  belongs_to :matter
  belongs_to :supplier
end
