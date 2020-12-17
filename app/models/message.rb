class Message < ApplicationRecord
  
  # messegeの新規インスタンスをそのままTalkRoomBroadcastJobに渡す
  # after_create_commit { TalkRoomBroadcastJob.perform_later self }
  
  belongs_to :matter, dependent: :destroy
  belongs_to :estimate_matter, dependent: :destroy
  has_many :certificates
  has_one_attached :photo

  def poster
    if self.admin_id.present?
      Admin.find(admin_id).name
    elsif self.manager_id.present?
      Manager.find(manager_id).name
    elsif self.staff_id.present?
      Staff.find(staff_id).name
    elsif self.external_staff_id.present?
      ExternalStaff.find(external_staff_id).name
    end
  end
end
