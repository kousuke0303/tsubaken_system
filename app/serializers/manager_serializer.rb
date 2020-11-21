class ManagerSerializer
  include FastJsonapi::ObjectSerializer
  attributes
  has_many :matters, serializer: MatterSerializer
end
