class TalkRoomChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from 'talk_room_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    # ActionCable.server.broadcast 'talk_room_channel', message: data['message']
    if data["admin_id"]
      message = Message.new(message: data["message"], matter_id: data["matter_id"], admin_id: data["admin_id"])
    elsif data['manager_id']
      message = Message.new(message: data["message"], matter_id: data["matter_id"], manager_id: data["manager_id"])
    elsif data["staff_id"]
      message = Message.new(message: data["message"], matter_id: data["matter_id"], staff_id: data["staff_id"])
    elsif data['external_staff_id']
      message = Message.new(message: data["message"], matter_id: data["matter_id"], external_staff_id: data["external_staff_id"])
    end
    message.save
    # messages = Message.where(matter_id: message.matter_id).last(6)
    # messages_by_date = messages.group_by{|list| list.created_at.to_date} 
    # ActionCable.server.broadcast("talk_room_channel", message: message)
  end
end
