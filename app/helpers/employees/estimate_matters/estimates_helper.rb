module Employees::EstimateMatters::EstimatesHelper
  
  def estimate_type(number)
    type = ["A", "B", "C", "D", "E", "F", "G", "H"]
    return type[number]
  end
  
  def estimate_plan(id)
    Estimate.find(id).title
  end
  
  def category_name(id)
    Category.find(id).name
  end
  
  def plan_row_span(id)
    line_2_count = Estimate.find(id).categories.count
    material_count = Estimate.joins(categories: :materials).where(id: id).count
    construction_count = Estimate.joins(categories: :constructions).where(id: id).count
    line_3_count = material_count + construction_count
    if line_2_count > line_3_count
      return line_2_count
    else
      if Category.left_joins(:materials, :constructions).where(estimate_id: id).where(materials: { category_id: nil}).where(constructions: {category_id: nil}).present?
        return line_3_count + 1
      else
        return line_3_count
      end
    end
  end
  
  def category_row_span(category)
    if category.present?
      if category.materials.present?
        material_count = category.materials.count
      else
        material_count = 0
      end
      if category.constructions.present? 
        construction_count = category.constructions.count
      else
        construction_count = 0
      end
      return material_count + construction_count
    end
  end
end
