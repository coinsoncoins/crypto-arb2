
require 'open-uri'
require 'json'
require './app/exchange'
require './app/currency_converter'

class LivecoinClient
  attr_accessor :url, :exchange
  def initialize()
    @exchange = Exchange.new('livecoin')
    @url = "https://api.livecoin.net/exchange/ticker"
  end

  def get_exchange()
    source = open(@url).read
    parse_snapshot(JSON.parse(source))
  end

  def parse_snapshot(snapshot)
    snapshot.each do |tradeable|
      name = tradeable["symbol"].gsub("/", '-')
      volume = tradeable["volume"].to_f * tradeable["last"].to_f # volume in bitcoin
      crypto = CryptoPair.new(name: name, bid: tradeable["best_bid"], ask: tradeable["best_ask"], volume_24h: volume)
      @exchange.add_crypto(crypto)
    end
    @exchange
  end

end
