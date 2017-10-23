
require 'open-uri'
require 'json'
require './app/exchange'

class BinanceClient
  attr_accessor :url, :exchange
  def initialize()
    @exchange = Exchange.new('binance')
    @url = "https://www.binance.com/api/v1/ticker/allBookTickers"
  end

  def get_exchange()
    source = open(@url).read
    parse_snapshot(JSON.parse(source))
  end

  def parse_snapshot(snapshot)
    snapshot.each do |tradeable|
      name = tradeable["symbol"].split("-").reverse.join
      crypto = CryptoPair.new(name: tradeable["symbol"], bid: tradeable["bidPrice"], ask: tradeable["askPrice"], volume_24h: nil)
      @exchange.add_crypto(crypto)
    end
    @exchange
  end

end
