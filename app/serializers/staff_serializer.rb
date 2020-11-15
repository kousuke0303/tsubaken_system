class StaffSerializer
  include FastJsonapi::ObjectSerializer
  attributes
  has_many :matters, serializer: MatterSerializer
end
