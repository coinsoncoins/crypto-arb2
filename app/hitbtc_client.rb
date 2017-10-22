
require 'open-uri'
require 'json'
require './app/exchange'

class HitBtcClient
  attr_accessor :url, :exchange
  def initialize()
    @exchange = Exchange.new('hitbtc')
    @url = "https://api.hitbtc.com/api/1/public/ticker"
  end

  def get_exchange()
    source = open(@url).read
    parse_snapshot(JSON.parse(source))
  end

  def parse_snapshot(snapshot)
    # snapshot is hash with keys being the crypto-tradingpair
    # {"BCNBTC":{"ask":"0.0000002504","bid":"0.0000002501","last":"0.0000002504",...
    snapshot.each do |key, value| 
      crypto = Crypto.new(name: key, bid: value["bid"], ask: value["ask"], volume_24h: value["volume_quote"])
      @exchange.add_crypto(crypto)
    end
    @exchange
  end

end
