
require 'open-uri'
require 'json'
require './app/exchange'
require './app/order_book'
require 'pry'
require 'httparty'


class EtherDeltaClient
  attr_accessor :url, :exchange, :path_to_data
  def initialize()
    @exchange = Exchange.new('etherdelta', self)
    @path_to_data = './exchange_data/etherdelta'
  end

  def get_exchange()
    Dir.foreach(@path_to_data) do |filename|
      next if filename == '.' or filename == '..'
      market = Market.new(name: filename.sub(/\.json$/, ''))
      order_book = get_order_book(market)
      next if !order_book.bids.first || !order_book.asks.first
      market.bid = order_book.bids.first.price
      market.ask = order_book.asks.first.price
      @exchange.add_market(market)
    end
    @exchange
  end

  def get_order_book(market)
    filename = "#{@path_to_data}/#{market.name}.json"
    contents = JSON.parse(open(filename).read)
    bids = contents["orders"]["buys"]
    asks = contents["orders"]["sells"] 
    order_book = OrderBook.new(market)
    bids.each do |bid|
      order_book.add_entry(quantity: bid["ethAvailableVolume"], price: bid["price"], side: 'bid')
    end
    asks.each do |ask|
      order_book.add_entry(quantity: ask["ethAvailableVolume"], price: ask["price"], side: 'ask')
    end
    order_book.finish_adding_entries()
  end

  def format_symbol(original_symbol)
    original_symbol.split("_").reverse.join('-')
  end

  def original_symbol(symbol)
    symbol.split('-').reverse.join('_')
  end
end
