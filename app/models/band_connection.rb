class BandConnection < ApplicationRecord
  belongs_to :estimate_matter, optional: true
  belongs_to :matter, optional: true
  
  attr_accessor :object
  attr_accessor :action_type
end
