
require 'open-uri'
require 'json'
require './app/exchange'
require './app/order_book'

class BinanceClient
  attr_accessor :url, :exchange, :order_book_url
  def initialize()
    @exchange = Exchange.new('binance', self)
    @url = "https://www.binance.com/api/v1/ticker/allBookTickers"
    @order_book_url = "https://www.binance.com/api/v1/depth?symbol=%s"
  end

  def get_exchange()
    source = open(@url).read
    parse_snapshot(JSON.parse(source))
  end

  def parse_snapshot(snapshot)
    snapshot.each do |tradeable|
      name = CryptoPair.parse_base(tradeable["symbol"]).join('-')
      crypto = CryptoPair.new(name: name, bid: tradeable["bidPrice"], ask: tradeable["askPrice"], volume_24h: nil)
      @exchange.add_crypto_pair(crypto)
    end
    @exchange
  end

  def get_order_book(crypto_pair)
    source = open(@order_book_url % crypto_pair_name_on_service(crypto_pair)).read
    entries = JSON.parse(source)
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

  def crypto_pair_name_on_service(crypto_pair)
    crypto_pair.name.sub('-', '')
  end

end
