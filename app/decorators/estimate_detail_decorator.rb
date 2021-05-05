# frozen_string_literal: true

module EstimateDetailDecorator
  
  def object_name
    if self.material_id.present?
      material_name
    elsif self.construction_id.present?
      construction_name
    end
  end
end
