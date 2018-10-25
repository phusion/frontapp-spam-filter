require 'action_view'

class MessageService
  include ActionView::Helpers::SanitizeHelper

  def mark_spam(front_id, text)
    message = Message.find_or_create_by(front_id: front_id)
    message.update_attributes!(
      body: text,
      stripped_body: strip_tags(text),
      spam: true
    )
  end

  def mark_ham(front_id, text)
    message = Message.find_or_create_by(front_id: front_id)
    message.update_attributes!(
      body: text,
      stripped_body: strip_tags(text),
      spam: false
    )
  end
end