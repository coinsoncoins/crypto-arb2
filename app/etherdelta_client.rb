
require 'open-uri'
require 'json'
require './app/exchange'
require './app/order_book'
require 'pry'

class EtherDeltaClient
  attr_accessor :url, :exchange, :order_book_url
  def initialize()
    @exchange = Exchange.new('etherdelta', self)
    @url = "https://api.etherdelta.com/returnTicker"
    @order_book_url = "https://api.etherdelta.com/orders/%s/0"
  end

  def get_exchange()
    summaries = JSON.parse(open(@url).read)
    parse_summaries(summaries)
  end


  def parse_summaries(summaries)
    summaries.each do |symbol, tradeable|
      name = symbol.split("_").reverse.join('-')
      crypto = CryptoPair.new(token_addr: tradeable["tokenAddr"], name: name, 
        bid: tradeable["bid"], ask: tradeable["ask"], volume_24h: tradeable["baseVolume"])
      @exchange.add_crypto_pair(crypto)
    end
    @exchange
  end

  def get_order_book(crypto_pair)
    source = open(@order_book_url % crypto_pair.token_addr).read
    entries = JSON.parse(source)
    bids = entries["buys"]
    asks = entries["sells"]
    order_book = OrderBook.new
    bids.each do |bid|
      order_book.add_entry(quantity: bid["amount"], price: bid["price"], side: 'bid')
    end
    asks.each do |ask|
      order_book.add_entry(quantity: ask["amount"], price: ask["price"], side: 'ask')
    end
    order_book.finish_adding_entries()
  end

  def crypto_pair_name_on_service(crypto_pair)
    crypto_pair.name.split('-').reverse.join('_')
  end
end
