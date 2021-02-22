class BandConnection < ApplicationRecord
  belongs_to :estimate_matter, optional: true
  belongs_to :matter, optional: true
end
