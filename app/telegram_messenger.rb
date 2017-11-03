
require 'telegram/bot'

class TelegramMessenger
  class << self
    def bot
      token = ENV["CRYPTO_ARB_TELEGRAM_TOKEN"]
      @bot ||= Telegram::Bot::Client.new(token)
    end

    def send(message)
      chat_id = ENV["CRYPTO_ARB_TELEGRAM_CHAT_ID"]
      bot.api.send_message(chat_id: chat_id, text: message)
    end
  end
end