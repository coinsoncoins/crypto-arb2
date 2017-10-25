
require 'open-uri'
require 'json'
require './app/exchange'
require './app/order_book'

class KucoinClient
  attr_accessor :url, :exchange, :order_book_url
  def initialize()
    @exchange = Exchange.new('kucoin', self)
    @url = "https://api.kucoin.com/v1/market/open/symbols"
    #@order_book_url = "https://bittrex.com/api/v1.1/public/getorderbook?market=%s&type=both"
  end

  def get_exchange()
    source = open(@url).read
    json_obj = JSON.parse(source)
    parse_snapshot(json_obj["data"])
  end


  def parse_snapshot(snapshot)
    snapshot.each do |tradeable|
      name = tradeable["symbol"]
      crypto = CryptoPair.new(name: name, bid: tradeable["buy"], ask: tradeable["sell"], volume_24h: tradeable["volValue"])
      @exchange.add_crypto_pair(crypto)
    end
    @exchange
  end

  # def get_order_book(crypto_pair)
  #   source = open(@order_book_url % crypto_pair_name_on_service(crypto_pair)).read
  #   entries = JSON.parse(source)["result"]
  #   bids = entries["buy"]
  #   asks = entries["sell"]
  #   order_book = OrderBook.new
  #   bids.each do |bid|
  #     order_book.add_entry(quantity: bid["Quantity"], price: bid["Rate"], side: 'bid')
  #   end
  #   asks.each do |ask|
  #     order_book.add_entry(quantity: ask["Quantity"], price: ask["Rate"], side: 'ask')
  #   end
  #   order_book.finish_adding_entries()
  # end

  def crypto_pair_name_on_service(crypto_pair)
    crypto_pair.name.split('-').reverse.join('-')
  end
end
