class AdoptedEstimateDetail < ApplicationRecord
  has_many :adopted_estimate_details, dependent: :destroy
end
