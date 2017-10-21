
require 'open-uri'
require 'json'

class BittrexClient
  def initialize()
    @markets = {}
  end

  def get_snapshot()
    url = "https://bittrex.com/api/v1.1/public/getmarketsummaries"
    source = open(url).read
    json_obj = JSON.parse(source)
    parse_markets(json_obj["result"])
  end

  def parse_markets(markets)
    markets.each do |market|
      @markets[market["MarketName"]] = market["Last"].to_f
    end
    @markets
  end

end

client = BittrexClient.new
puts client.get_snapshot
