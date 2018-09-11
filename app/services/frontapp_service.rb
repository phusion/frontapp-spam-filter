class FrontappService

  def initialize
    @frontapp =  Frontapp::Client.new(auth_token: Rails.application.credentials.frontapp_token) 
    @messages_cache = {}
  end

  def mark_spam(conversation)
    # move to spam inbox, add spam tag, removing all other tags
    @frontapp.update_conversation!(conversation['id'], {
      tags: [spam_tag_name],
      inbox_id: spam_inbox_id
    })
  end

  def mark_ham(conversation)
    # remove spam tag, but keep other tags
    cnv = @frontapp.get_conversation(conversation['id'])
    new_tags = cnv['tags'].map { |t| t['name'] if t['name'] != spam_tag_name }.compact
    @frontapp.update_conversation!(conversation['id'], {
      tags: new_tags
    })
  end

  def get_message(conversation)
    @messages_cache[conversation['id']] ||= @frontapp.get_conversation_messages(conversation['id'])
    @messages_cache[conversation['id']][0]['text']
  end

  def has_single_message?(conversation)
    @messages_cache[conversation['id']] ||= @frontapp.get_conversation_messages(conversation['id'])
    @messages_cache[conversation['id']].count == 1
  end

  def in_spam_inbox?(conversation)
    inboxes = @frontapp.get_conversation_inboxes(conversation['id'])
    inboxes['_results'].any? { |i| i['id'] == spam_inbox_id }
  end

  def has_spam_tag?(conversation)
    cnv = @frontapp.get_conversation(conversation['id'])
    cnv['tags'].any? { |t| t['name'] == spam_tag_name }
  end

private

  def spam_tag_name
    Rails.application.credentials.frontapp_spam_tag_name
  end

  def spam_inbox_id
    Rails.application.credentials.frontapp_spam_inbox_id
  end

end