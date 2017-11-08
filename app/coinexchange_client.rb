
require 'open-uri'
require 'json'
require './app/exchange'
require './app/order_book'
require 'pry'
require 'httparty'

class CoinExchangeClient
  attr_accessor :url, :exchange, :order_book_url, :markets_url
  def initialize()
    @exchange = Exchange.new('coinexchange', self)
    @url = "https://www.coinexchange.io/api/v1/getmarketsummaries"
    @markets_url = "https://www.coinexchange.io/api/v1/getmarkets"
    @order_book_url = "https://www.coinexchange.io/api/v1/getorderbook?market_id=%d"
  end

  def get_exchange()
    summaries = JSON.parse(open(@url).read)["result"]
    markets = JSON.parse(open(@markets_url).read)["result"]
    summaries.each do |summary|
      market = markets.detect { |m| m["MarketID"] == summary["MarketID"] }
      summary.merge!(market)
    end
    parse_summaries(summaries)
  end


  def parse_summaries(summaries)
    summaries.each do |tradeable|
      name = tradeable["MarketAssetCode"] + "-" + tradeable["BaseCurrencyCode"]
      crypto = Market.new(id: tradeable["MarketID"], name: name, 
        bid: tradeable["BidPrice"], ask: tradeable["AskPrice"], volume_24h: tradeable["BTCVolume"])
      @exchange.add_market(crypto)
    end
    @exchange
  end

  def get_order_book(market)
    url = @order_book_url % market.id
    response = HTTParty.get(url, { timeout: 10 })
    entries = JSON.parse(response.body)["result"]
    bids = entries["BuyOrders"]
    asks = entries["SellOrders"]
    order_book = OrderBook.new(market)
    bids.each do |bid|
      order_book.add_entry(quantity: bid["Quantity"], price: bid["Price"], side: 'bid')
    end
    asks.each do |ask|
      order_book.add_entry(quantity: ask["Quantity"], price: ask["Price"], side: 'ask')
    end
    order_book.finish_adding_entries()
  end
end
