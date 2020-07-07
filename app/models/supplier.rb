class Supplier < ApplicationRecord
  belongs_to :manager
  
  scope :for_order_count, -> { order(count: "DESC") } 
end
