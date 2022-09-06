class LiveChannel < ApplicationCable::Channel
  def subscribed
    stream_from "live_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak
    ActionCable.server.broadcast(
      "live_channel", {group_comment: data["group_comment"]}
    )
  end
end
