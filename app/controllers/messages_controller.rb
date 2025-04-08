require_relative '../services/slack_service'
require_relative '../services/translation_service'
require_relative '../services/message_logger'
require 'erb'

class MessagesController
  def self.list_messages
    @messages = MessageLogger.load_messages.reverse
    ERB.new(File.read('app/views/index.erb')).result(binding)
  end

  def self.send_message(texto)
    translated = TranslationService.translate_to_english(texto)
    SlackService.send_message(translated)

    MessageLogger.log({
      origem: 'usuario',
      original: texto,
      translated: translated,
      timestamp: Time.now.to_s
    })

    { status: 'ok' }.to_json
  end

  def self.all_messages
    MessageLogger.load_messages
  end
end