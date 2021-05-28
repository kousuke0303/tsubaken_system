class BadgeChannel < ApplicationCable::Channel
  def subscribed
    stream_from "badge_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    ActionCable.server.broadcast('badge_channel', data)
  end
end
