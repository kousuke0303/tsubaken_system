class AttendanceSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, worked_on
end
