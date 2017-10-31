
require 'open-uri'
require 'json'
require './app/exchange'
require './app/order_book'

class LiquiClient
  attr_accessor :url, :exchange, :trade_pairs_url, :order_book_url
  def initialize()
    @exchange = Exchange.new('liqui', self)
    @url = "https://api.liqui.io/api/3/ticker/"
    @trade_pairs_url = "https://api.liqui.io/api/3/info"
    @order_book_url = "https://api.liqui.io/api/3/depth/%s"
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
      crypto = Market.new(name: name, bid: value["buy"], ask: value["sell"], volume_24h: value["vol"])
      @exchange.add_market(crypto)
    end
    @exchange
  end

  def get_order_book(market)
    source = open(@order_book_url % market_name_on_service(market)).read
    entries = JSON.parse(source)
    if entries['error']
      raise RuntimeError.new("LiquiClient Error: #{entries['error']}")
    end
    entries = entries[entries.keys.first]
    bids = entries["bids"]
    asks = entries["asks"]
    order_book = OrderBook.new
    bids.each do |bid|
      order_book.add_entry(quantity: bid[1], price: bid[0], side: 'bid')
    end
    asks.each do |ask|
      order_book.add_entry(quantity: ask[1], price: ask[0], side: 'ask')
    end
    order_book.finish_adding_entries()
  end

  def market_name_on_service(market)
    market.name.sub('-', '_').downcase
  end

end
