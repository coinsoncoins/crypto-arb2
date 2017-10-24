
require 'open-uri'
require 'json'
require './app/exchange'

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
      name = CryptoPair.parse_base(key).join('-')
      crypto = CryptoPair.new(name: name, bid: value["bid"], ask: value["ask"], volume_24h: value["volume_quote"])
      @exchange.add_crypto_pair(crypto)
    end
    @exchange
  end

  def get_order_book(crypto_pair)
    source = open(@order_book_url % crypto_pair.name.sub('-', '')).read
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

end
