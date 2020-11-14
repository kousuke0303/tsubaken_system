class MatterSerializer
  include FastJsonapi::ObjectSerializer
  attributes
  belongs_to :client, serializer: ClientSerializer
end
