
require 'open-uri'
require 'json'
require './app/exchange'
require './app/order_book'

class BittrexClient
  attr_accessor :url, :exchange, :order_book_url
  def initialize()
    @exchange = Exchange.new('bittrex')
    @url = "https://bittrex.com/api/v1.1/public/getmarketsummaries"
    # example "https://bittrex.com/api/v1.1/public/getorderbook?market=BTC-NAV&type=both"
    @order_book_url = "https://bittrex.com/api/v1.1/public/getorderbook?market=%stype=both"
  end

  def get_exchange()
    source = open(@url).read
    json_obj = JSON.parse(source)
    parse_snapshot(json_obj["result"])
  end


  def parse_snapshot(snapshot)
    snapshot.each do |tradeable|
      name = tradeable["MarketName"].split("-").reverse.join('-')
      crypto = CryptoPair.new(name: name, bid: tradeable["Bid"], ask: tradeable["Ask"], volume_24h: tradeable["BaseVolume"])
      @exchange.add_crypto(crypto)
    end
    @exchange
  end

  def get_order_book(crypto_pair)
    source = open(@order_book_url % crypto_pair.name).read
    entries = JSON.parse(source)["result"]
    bids = entries["buy"]
    asks = entries["sell"]
    order_book = OrderBook.new
    bids.each do |bid|
      order_book.add_entry(quantity: bid["Quantity"], price: bid["Rate"], side: 'bid')
    end
    asks.each do |ask|
      order_book.add_entry(quantity: ask["Quantity"], price: ask["Rate"], side: 'ask')
    end
    order_book.finish_adding_entries()
  end
end
