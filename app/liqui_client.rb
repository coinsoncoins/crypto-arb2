
require 'open-uri'
require 'json'
require './app/exchange'

class LiquiClient
  attr_accessor :url, :exchange, :trade_pairs_url
  def initialize()
    @exchange = Exchange.new('liqui')
    @url = "https://api.liqui.io/api/3/ticker/"
    @trade_pairs_url = "https://api.liqui.io/api/3/info"
  end

  def get_exchange()
    # first we have to get all the trade-pairs listed on liqui and put them in the url
    trade_pairs_json = JSON.parse(open(@trade_pairs_url).read)
    trade_pairs = trade_pairs_json['pairs'].keys()
    @url += trade_pairs.join('-')
    source = open(url).read
    parse_snapshot(JSON.parse(source))
  end


  def parse_snapshot(snapshot)
    snapshot.each do |key, value| 
      name = key.gsub('_', '-').upcase
      crypto = CryptoPair.new(name: name, bid: value["buy"], ask: value["sell"], volume_24h: value["vol"])
      @exchange.add_crypto(crypto)
    end
    @exchange
  end

end
