class EstimateDetail < ApplicationRecord
  belongs_to :estimate
  belongs_to :category
  belongs_to :material, optional: true
  belongs_to :construction, optional: true
  
end
