class MatterSerializer
  include FastJsonapi::ObjectSerializer
  attributes
  belongs_to :client, serializer: ClientSerializer
  belongs_to :manager, serializer: ManagerSerializer
  belongs_to :staff, serializer: StaffSerializer
end
