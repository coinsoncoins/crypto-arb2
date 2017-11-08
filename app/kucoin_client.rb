
require 'open-uri'
require 'json'
require './app/exchange'
require './app/order_book'
require 'httparty'

class KucoinClient
  attr_accessor :url, :exchange, :order_book_url
  def initialize()
    @exchange = Exchange.new('kucoin', self)
    @url = "https://api.kucoin.com/v1/market/open/symbols"
    @order_book_url = "https://api.kucoin.com/v1/open/orders?symbol=%s"
  end

  def get_exchange()
    source = open(@url).read
    json_obj = JSON.parse(source)
    parse_snapshot(json_obj["data"])
  end


  def parse_snapshot(snapshot)
    snapshot.each do |tradeable|
      name = tradeable["symbol"]
      crypto = Market.new(name: name, bid: tradeable["buy"], ask: tradeable["sell"], volume_24h: tradeable["volValue"])
      @exchange.add_market(crypto)
    end
    @exchange
  end

  def get_order_book(market)
    url = @order_book_url % market.name
    response = HTTParty.get(url, { timeout: 10 })
    entries = JSON.parse(response.body)["data"]
    bids = entries["BUY"]
    asks = entries["SELL"]
    order_book = OrderBook.new(market)
    bids.each do |bid|
      order_book.add_entry(quantity: bid[1], price: bid[0], side: 'bid')
    end
    asks.each do |ask|
      order_book.add_entry(quantity: ask[1], price: ask[0], side: 'ask')
    end
    order_book.finish_adding_entries()
  end

end
