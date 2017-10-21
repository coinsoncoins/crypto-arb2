
require 'open-uri'
require 'json'

class BinanceClient
  def initialize()
    @markets = {}
  end

  def get_snapshot()
    url = "https://www.binance.com/api/v1/ticker/allPrices"
    source = open(url).read
    parse_snapshot(source)
  end

  def parse_snapshot(snapshot_string)
    json_obj = JSON.parse(snapshot_string)
    parse_markets(json_obj)
  end

  def parse_markets(markets)
    markets.each do |market|
      @markets[market["symbol"]] = market["price"].to_f
    end
    @markets
  end

end
