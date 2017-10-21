
require 'open-uri'
require 'json'

class BittrexClient
  def initialize()
    @markets = {}
  end

  def get_snapshot()
    url = "https://bittrex.com/api/v1.1/public/getmarketsummaries"
    source = open(url).read
    parse_snapshot(source)
  end

  def parse_snapshot(snapshot_string)
    json_obj = JSON.parse(snapshot_string)
    parse_markets(json_obj["result"])
  end

  def parse_markets(markets)
    markets.each do |market|
      market_name = market["MarketName"].split("-").reverse.join
      @markets[market_name] = {
        bid: market["Bid"].to_f, 
        ask: market["Ask"].to_f,
        volume: market["BaseVolume"].to_f
      }
    end
    @markets
  end

end
