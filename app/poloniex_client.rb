

require 'open-uri'
require 'json'
require './app/exchange'
require './app/order_book'
require './app/coin_name_remapper'

class PoloniexClient
  attr_accessor :url, :exchange, :order_book_url
  def initialize()
    @exchange = Exchange.new('poloniex', self)
    @url = "https://poloniex.com/public?command=returnTicker"
    @order_book_url = "https://poloniex.com/public?command=returnOrderBook&currencyPair=%s"
    @coin_name_remapper = CoinNameRemapper.new('poloniex')
  end

  def get_exchange()
    source = open(@url).read
    json_obj = JSON.parse(source)
    parse_snapshot(json_obj)
  end


  def parse_snapshot(snapshot)
    snapshot.each do |key, value|
      name = key.split('_').reverse.join('-') # BTC_BCN
      name = @coin_name_remapper.map(name)
      crypto = Market.new(name: name, bid: value["highestBid"], ask: value["lowestAsk"], volume_24h: value["baseVolume"])
      @exchange.add_market(crypto)
    end
    @exchange
  end

  def get_order_book(market)
    source = open(@order_book_url % market_name_on_service(market)).read
    entries = JSON.parse(source)
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
    name = @coin_name_remapper.unmap(market.name)
    market.name.split('-').reverse.join('_')
  end

end
