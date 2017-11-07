
require 'telegram/bot'
require './app/secrets'

class TelegramMessenger
  class << self
    def bot
      token = Secrets.get["telegram"]["token"]
      @bot ||= Telegram::Bot::Client.new(token)
    end

    def send(message)
      chat_id = Secrets.get["telegram"]["chat_id"]
      bot.api.send_message(chat_id: chat_id, text: message)
    end
  end
end