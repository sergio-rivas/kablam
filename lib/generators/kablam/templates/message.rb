# require 'rest-client'
class Message < ApplicationRecord
  belongs_to :chat
  has_many :message_statuses, dependent: :destroy
  after_commit :setup_status, :set_updated_at
  after_commit :broadcast_self, on: :create

  def self.slack_hook
    # "http://insert-slack-hook-here"
    nil
  end

  def self.slack_message
    {create: {
      pretext: "New Message from #{user.name}",
      author: "#{user.name}",
      title: "chat.subject",
      text: "#{content}"
      }
    }
  end

  def setup_status
    MessageStatus.create(user_id: self.chat.user_id, message_id: self.id)
  end

  def set_updated_at
    @chat = self.chat
    @chat.update(updated_at: self.created_at)
    # @chat.save
  end

  def status(user_id)
    MessageStatus.find_by(user_id: user_id, message_id: self.id).read
  end

  def user
    User.find(self.sender_id.to_i)
  end

  def broadcast_self
    ActionCable.server.broadcast "AdminChannel", {chat_id: "#{chat.id}_#{sender_id}" }

    chat.users.each do |u|
      ActionCable.server.broadcast "DotChannel_#{u}", {dot: "#{sender_id}" }
    end
  end

  def user_time
    u = User.find(self.sender_id.to_i)
    ActiveSupport::TimeZone[u.timezone].now if !u.timezone.nil?
  end
end
