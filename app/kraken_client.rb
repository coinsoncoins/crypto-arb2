
# require 'open-uri'
# require 'json'
# require './app/exchange'

# class KrakenClient
#   attr_accessor :url, :exchange, :trade_pairs_url
#   def initialize()
#     @exchange = Exchange.new('kraken')
#     @url = "https://api.kraken.com/0/public/Ticker?pair="
#     @trade_pairs_url = "https://api.kraken.com/0/public/AssetPairs"
#   end

#   def get_exchange()
#     # first we have to get all the trade-pairs listed on kraken and put them in the url
#     trade_pairs_json = JSON.parse(open(@trade_pairs_url).read)
#     trade_pairs = trade_pairs_json['result'].keys()
#     @url += trade_pairs.join(',')
#     source = open(url).read
#     json_obj = JSON.parse(source)
#     parse_snapshot(json_obj["result"])
#   end


#   def parse_snapshot(snapshot)
#     snapshot.each do |key, value| 
#       name = key.gsub('_', '').upcase
#       crypto = Crypto.new(name: name, bid: value["buy"], ask: value["sell"], volume_24h: value["vol"])
#       @exchange.add_crypto(crypto)
#     end
#     @exchange
#   end

# end
