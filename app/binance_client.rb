
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
      parsed_name = parse_base(tradeable["symbol"])
      name = "#{parsed_name[0]}-#{parsed_name[1]}"
      crypto = CryptoPair.new(name: name, bid: tradeable["bidPrice"], ask: tradeable["askPrice"], volume_24h: nil)
      @exchange.add_crypto(crypto)
    end
    @exchange
  end

  def parse_base(name)
    base = /BTC$|ETC$|LTC$/.match(name).to_s
    crypto = name.sub(base, '')
    [crypto, base]
  end

end
