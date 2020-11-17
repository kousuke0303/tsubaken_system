class MatterManager < ApplicationRecord
  belongs_to :matter, inverse_of: :matter_managers
  belongs_to :manager
end
