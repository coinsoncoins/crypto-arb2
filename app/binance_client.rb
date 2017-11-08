
require 'open-uri'
require 'json'
require './app/exchange'
require './app/order_book'
require 'httparty'

class BinanceClient
  attr_accessor :url, :exchange, :order_book_url
  def initialize()
    @exchange = Exchange.new('binance', self)
    @url = "https://www.binance.com/api/v1/ticker/allBookTickers"
    @order_book_url = "https://www.binance.com/api/v1/depth?symbol=%s"
  end

  def get_exchange()
    source = open(@url).read
    parse_summaries(JSON.parse(source))
  end

  def parse_summaries(summaries)
    summaries.each do |tradeable|
      begin
        name = Market.parse_base(tradeable["symbol"]).join('-')
        market = Market.new(name: name, bid: tradeable["bidPrice"], ask: tradeable["askPrice"], volume_24h: nil)
        @exchange.add_market(market)       
      rescue BadMarketNameError => e
        raise unless e.name == '123456' || e.name == 'ETC' # binance has these errors in its API, ignore
      end
    end
    @exchange
  end

  def get_order_book(market)
    url = @order_book_url % market_name_on_service(market)
    response = HTTParty.get(url, { timeout: 10 })
    entries = JSON.parse(response.body)
    bids = entries["bids"]
    asks = entries["asks"]
    order_book = OrderBook.new(market)
    bids.each do |bid|
      order_book.add_entry(quantity: bid[1], price: bid[0], side: 'bid')
    end
    asks.each do |ask|
      order_book.add_entry(quantity: ask[1], price: ask[0], side: 'ask')
    end
    order_book.finish_adding_entries()
  end

  def market_name_on_service(market)
    market.name.sub('-', '')
  end

end
