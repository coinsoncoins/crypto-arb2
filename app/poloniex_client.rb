

require 'open-uri'
require 'json'
require './app/exchange'

class PoloniexClient
  attr_accessor :url, :exchange
  def initialize()
    @exchange = Exchange.new('poloniex')
    @url = "https://poloniex.com/public?command=returnTicker"
  end

  def get_exchange()
    source = open(@url).read
    json_obj = JSON.parse(source)
    parse_snapshot(json_obj)
  end


  def parse_snapshot(snapshot)
    snapshot.each do |key, value|
      name = key.split('_').reverse.join('-') # BTC_BCN
      crypto = CryptoPair.new(name: name, bid: value["highestBid"], ask: value["lowestAsk"], volume_24h: value["baseVolume"])
      @exchange.add_crypto_pair(crypto)
    end
    @exchange
  end

end
