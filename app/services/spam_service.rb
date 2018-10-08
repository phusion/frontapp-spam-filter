class SpamService

  def is_spam?(message)
    Plino.spam?(message)
  end

  def mark_spam(message)
  end

  def mark_ham(message)
  end

private

end