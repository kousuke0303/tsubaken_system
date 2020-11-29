class Message < ApplicationRecord
  
  # messegeの新規インスタンスをそのままTalkRoomBroadcastJobに渡す
  after_create_commit { TalkRoomBroadcastJob.perform_later self }
  
  belongs_to :matter, optional: true
  has_one_attached :photo
end
