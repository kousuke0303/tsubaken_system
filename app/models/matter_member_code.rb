class MatterMemberCode < ApplicationRecord
  belongs_to :matter
  belongs_to :member_code
end
