
require 'open-uri'
require 'json'
require './app/exchange'

class CryptopiaClient
  attr_accessor :url, :exchange
  def initialize()
    @exchange = Exchange.new('cryptopia', self)
    @url = "https://www.cryptopia.co.nz/api/GetMarkets"
  end

  def get_exchange()
    source = open(@url).read
    json_obj = JSON.parse(source)
    parse_snapshot(json_obj["Data"])
  end


  def parse_snapshot(snapshot)
    snapshot.each do |tradeable|
      name = tradeable["Label"].split("/").join('-')
      crypto = CryptoPair.new(name: name, bid: tradeable["BidPrice"], ask: tradeable["AskPrice"], volume_24h: tradeable["BaseVolume"])
      @exchange.add_crypto_pair(crypto)
    end
    @exchange
  end

end
