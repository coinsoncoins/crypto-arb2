
require 'open-uri'
require 'json'
require './app/exchange'
require 'httparty'

class HitBtcClient
  attr_accessor :url, :exchange, :order_book_url
  def initialize()
    @exchange = Exchange.new('hitbtc', self)
    @url = "https://api.hitbtc.com/api/1/public/ticker"
    @order_book_url = "https://api.hitbtc.com/api/1/public/%s/orderbook"
  end

  def get_exchange()
    source = open(@url).read
    parse_snapshot(JSON.parse(source))
  end

  def parse_snapshot(snapshot)
    # snapshot is hash with keys being the crypto-tradingpair
    # {"BCNBTC":{"ask":"0.0000002504","bid":"0.0000002501","last":"0.0000002504",...
    snapshot.each do |key, value|
      name = Market.parse_base(key).join('-')
      crypto = Market.new(name: name, bid: value["bid"], ask: value["ask"], volume_24h: value["volume_quote"])
      @exchange.add_market(crypto)
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
