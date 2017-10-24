
require 'open-uri'
require 'json'
require './app/exchange'
require './app/order_book'

class CryptopiaClient
  attr_accessor :url, :exchange, :order_book_url
  def initialize()
    @exchange = Exchange.new('cryptopia', self)
    @url = "https://www.cryptopia.co.nz/api/GetMarkets"
    @order_book_url = "https://www.cryptopia.co.nz/api/GetMarketOrders/%s"
  end

  def get_exchange()
    source = open(@url).read
    json_obj = JSON.parse(source)
    parse_snapshot(json_obj["Data"])
  end


  def parse_snapshot(snapshot)
    snapshot.each do |tradeable|
      name = tradeable["Label"].split("/").join('-')
      crypto = CryptoPair.new(name: name, bid: tradeable["BidPrice"], ask: tradeable["AskPrice"], volume_24h: tradeable["BaseVolume"])
      @exchange.add_crypto_pair(crypto)
    end
    @exchange
  end

  def get_order_book(crypto_pair)
    source = open(@order_book_url % crypto_pair_name_on_service(crypto_pair)).read
    entries = JSON.parse(source)["Data"]
    bids = entries["Buy"]
    asks = entries["Sell"]
    order_book = OrderBook.new
    bids.each do |bid|
      order_book.add_entry(quantity: bid["Volume"], price: bid["Price"], side: 'bid')
    end
    asks.each do |ask|
      order_book.add_entry(quantity: ask["Volume"], price: ask["Price"], side: 'ask')
    end
    order_book.finish_adding_entries()
  end

  def crypto_pair_name_on_service(crypto_pair)
    crypto_pair.name.sub('-', '_')
  end

end
