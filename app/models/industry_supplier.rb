class IndustrySupplier < ApplicationRecord
  belongs_to :industry
  belongs_to :vendor
end
