class SendMessage
  def self.call(message)
    message.save
    if message.persisted?
      Counter.increment
      ForeignOffice.publish(channel: "Default", object: {message_count: Counter.total})
    end
  end
end