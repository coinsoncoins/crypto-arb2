
require 'open-uri'
require 'json'
require './app/exchange'
require './app/order_book'
require 'pry'
require 'httparty'

class BittrexClient
  attr_accessor :url, :exchange, :order_book_url
  def initialize()
    @exchange = Exchange.new('bittrex', self)
    @url = "https://bittrex.com/api/v1.1/public/getmarketsummaries"
    @order_book_url = "https://bittrex.com/api/v1.1/public/getorderbook?market=%s&type=both"
  end

  def get_exchange()
    source = open(@url).read
    json_obj = JSON.parse(source)
    parse_snapshot(json_obj["result"])
  end


  def parse_snapshot(snapshot)
    snapshot.each do |tradeable|
      name = tradeable["MarketName"].split("-").reverse.join('-')
      crypto = Market.new(name: name, bid: tradeable["Bid"], ask: tradeable["Ask"], volume_24h: tradeable["BaseVolume"])
      @exchange.add_market(crypto)
    end
    @exchange
  end

  def get_order_book(market)
    url = @order_book_url % market_name_on_service(market)
    response = HTTParty.get(url, { timeout: 10 })
    entries = JSON.parse(response.body)["result"]
    bids = entries["buy"]
    asks = entries["sell"]
    order_book = OrderBook.new(market)
    bids.each do |bid|
      order_book.add_entry(quantity: bid["Quantity"], price: bid["Rate"], side: 'bid')
    end
    asks.each do |ask|
      order_book.add_entry(quantity: ask["Quantity"], price: ask["Rate"], side: 'ask')
    end
    order_book.finish_adding_entries()
  end

  def market_name_on_service(market)
    market.name.split('-').reverse.join('-')
  end
end
