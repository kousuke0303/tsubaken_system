class VendorEstimateMatter < ApplicationRecord
  belongs_to :estimate_matter
  belongs_to :vendor
end
