
require 'open-uri'
require 'json'
require './app/exchange'

class BittrexClient
  attr_accessor :url, :exchange
  def initialize()
    @exchange = Exchange.new('bittrex')
    @url = "https://bittrex.com/api/v1.1/public/getmarketsummaries"
  end

  def get_exchange()
    source = open(@url).read
    json_obj = JSON.parse(source)
    parse_snapshot(json_obj["result"])
  end


  def parse_snapshot(snapshot)
    snapshot.each do |tradeable|
      name = tradeable["MarketName"].split("-").reverse.join
      crypto = Crypto.new(name: name, bid: tradeable["Bid"], ask: tradeable["Ask"], volume_24h: tradeable["BaseVolume"])
      @exchange.add_crypto(crypto)
    end
    @exchange
  end

end
