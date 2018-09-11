class HooksController < ApplicationController
  before_action :authenticate
  before_action :create_services

  # Triggered by a rule on certain inboxes
  def inbound
    begin
      conversation = params['conversation']
      message = @frontapp_service.get_message(conversation)
      if(@spam_service.is_spam?(message))
        @frontapp_service.mark_spam(conversation)
      end
      render json: { ok: true }
    rescue => e
      Rails.logger.error "[inbound] #{e.message}\n#{e.backtrace.join("\n")}"
      render json: { error: 'Oops, something did not go as planned' }, status: 500
    end
  end

  # Triggered by 2 rules
  # - on conversations with the spam tag and to certain inboxes
  # - on conversations without the spam tag and to the spam inbox
  # Moving a message with a spam tag implies to a non-spam folder means it is not spam.
  # Moving a message without a spam tag implies to a spam folder means it is spam.
  # Mark it as ham in the spam api and remove the spam tag.
  def move
    begin
      conversation = params['conversation']
      message = @frontapp_service.get_message(conversation)
      if(@frontapp_service.has_spam_tag?(conversation) && !@frontapp_service.in_spam_inbox?(conversation))
        # has spam tag and is moved to non-spam folder
        @spam_service.mark_ham(message)
        @frontapp_service.mark_ham(conversation)
      elsif !@frontapp_service.has_spam_tag?(conversation)
        # does not have spam tag and is moved to spam folder
        @spam_service.mark_spam(message)
        @frontapp_service.mark_spam(conversation)
      end
      render json: { ok: true }
    rescue => e
      Rails.logger.error "[move] #{e.message}\n#{e.backtrace.join("\n")}"
      render json: { error: 'Oops, something did not go as planned' }, status: 500
    end
  end

private

  def authenticate
    if params[:token] != Rails.application.credentials.token
      render json: { error: 'Invalid auth token' }, status: 403
    end
  end

  def create_services
    @frontapp_service = FrontappService.new
    @spam_service = SpamService.new
  end
end
