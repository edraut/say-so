class Counter < ActiveRecord::Base
  def self.increment
    self.message_counter.increment
  end

  def self.total
    self.message_counter.total
  end

  def self.message_counter
    @message_counter = self.where(countable: 'messages').first
    @message_counter ||= self.create(countable: 'messages')
    @message_counter
  end

  def increment
    self.total ||= 0
    self.total += 1
    self.save
  end
end