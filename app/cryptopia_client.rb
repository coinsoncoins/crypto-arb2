
require 'open-uri'
require 'json'
require './app/exchange'
require './app/order_book'
require './app/coin_name_remapper'
require 'httparty'

class CryptopiaClient
  attr_accessor :url, :exchange, :order_book_url
  def initialize()
    @exchange = Exchange.new('cryptopia', self)
    @url = "https://www.cryptopia.co.nz/api/GetMarkets"
    @order_book_url = "https://www.cryptopia.co.nz/api/GetMarketOrders/%s"
    @coin_name_remapper = CoinNameRemapper.new('cryptopia')
  end

  def get_exchange()
    source = open(@url).read
    json_obj = JSON.parse(source)
    parse_snapshot(json_obj["Data"])
  end


  def parse_snapshot(snapshot)
    snapshot.each do |tradeable|
      name = tradeable["Label"].split("/").join('-')
      name = @coin_name_remapper.map(name)
      crypto = Market.new(name: name, bid: tradeable["BidPrice"], ask: tradeable["AskPrice"], volume_24h: tradeable["BaseVolume"])
      @exchange.add_market(crypto)
    end
    @exchange
  end

  def get_order_book(market)
    url = @order_book_url % market_name_on_service(market)
    response = HTTParty.get(url, { timeout: 10 })
    entries = JSON.parse(response.body)["Data"]
    bids = entries["Buy"]
    asks = entries["Sell"]
    order_book = OrderBook.new(market)
    bids.each do |bid|
      order_book.add_entry(quantity: bid["Volume"], price: bid["Price"], side: 'bid')
    end
    asks.each do |ask|
      order_book.add_entry(quantity: ask["Volume"], price: ask["Price"], side: 'ask')
    end
    order_book.finish_adding_entries()
  end

  def market_name_on_service(market)
    name = @coin_name_remapper.unmap(market.name)
    name = market.name.sub('-', '_')
  end

end
