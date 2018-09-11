class SpamService

  def initialize
    @datumbox = Datumbox.new(Rails.application.credentials.datumbox_token)
  end

  def is_spam?(message)
    json = JSON.parse(@datumbox.spam_detection(text: message))
    json['output'] && json['output']['result'] && json['output']['result'] == 'spam'
  end

  def mark_spam(message)
    # not implemented because not supported by DatumBox
  end

  def mark_ham(message)
    # not implemented because not supported by DatumBox
  end

end