class ConstructionScheduleMaterial < ApplicationRecord
  belongs_to :construction_schedule
  belongs_to :material
end
