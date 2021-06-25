class VendorMatter < ApplicationRecord
  belongs_to :matter
  belongs_to :vendor
end
