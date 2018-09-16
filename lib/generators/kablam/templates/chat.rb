class Chat < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy
  has_many :message_statuses, through: :messages
  after_update_commit :broadcast_self

  def messages_array
    y = messages.map do |x|
      u = User.find(x.sender_id)
      h = x.serializable_hash
      # h["status"] = x.status(user_id)
      h["chat_id"] = id.to_s
      h["image"] = u.name? ? u.avatar_url(50) : "/assets/default.png"
      h['username'] = u.name || "An Amazing Person~"
      h["user_time"] = x.user_time
      h
    end
    y.sort_by{|x|x["created_at"]}
  end

  def latest_message
    messages_array.last
  end

  def unread_messages(user_id)
    message_statuses.where(user_id: user_id.to_i, read: false).count
  end

  def broadcast_self
    ActionCable.server.broadcast "ChatChannel_#{self.id}", {chat: messages_array.last }
  end

  def users
    messages.map{ |m| m.sender_id}.uniq
  end

  def not_answered(user_id)
    if !messages.blank?
      return messages.last.sender_id != user_id
    else
      return false
    end
  end
end
