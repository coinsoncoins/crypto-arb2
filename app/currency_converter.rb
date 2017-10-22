require 'open-uri'
require 'json'

class CurrencyConverter

  class << self
    attr_reader :BTCUSD, :ETHUSD, :api_url
  end

  @BTCUSD = 6000
  @ETHUSD = 300
  @api_url = "https://api.coinmarketcap.com/v1/ticker/"


  def initialize()
  end

  def self.get_quotes()
    source = JSON.parse(open(@api_url).read)
    @BTCUSD = source.detect{|c| c["id"] == "bitcoin"}["price_usd"].to_f
    @ETHUSD = source.detect{|c| c["id"] == "ethereum"}["price_usd"].to_f
  end

end