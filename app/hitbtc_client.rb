
require 'open-uri'
require 'json'

class HitBtcClient
  def initialize()
    @markets = {}
  end

  def get_snapshot()
    url = "https://api.hitbtc.com/api/1/public/ticker"
    source = open(url).read
    parse_snapshot(source)
  end

  def parse_snapshot(snapshot_string)
    json_obj = JSON.parse(snapshot_string)
    parse_markets(json_obj)
  end

  def parse_markets(markets)
    markets.each do |key, value|
      @markets[key] = {
        ask: value["ask"].to_f,
        bid: value["bid"].to_f,
        volume: value["volume_quote"].to_f
      }
    end
    @markets
  end

end
