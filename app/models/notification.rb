class Notification < ApplicationRecord
  belongs_to :schedule, optional: true
  belongs_to :sender, class_name: 'MemberCode', foreign_key: 'sender_id', optional: true
  belongs_to :reciever, class_name: 'MemberCode', foreign_key: 'reciever_id', optional: true

  enum status: { active: 0, close: 1 }
  enum category: {not_set: 0, schedule: 1}
end
