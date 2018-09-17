class SpamService

  def is_spam?(message)
    Akismet.spam?(ip, user_agent, text: message)
  end

  def mark_spam(message)
    Akismet.spam(ip, user_agent, text: message)
  end

  def mark_ham(message)
    Akismet.ham(ip, user_agent, text: message)
  end

private

  def ip
    '127.0.0.1'
  end

  def user_agent
    'FrontAppSpamFilter/1.0.0 | Akismet/2.0.0'
  end

end