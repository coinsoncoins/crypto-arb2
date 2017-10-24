require 'open-uri'
require 'json'

class CurrencyConverter

  class << self
    attr_reader :BTCUSD, :ETHUSD, :api_url
  end

  @BTCUSD = 6000.0
  @ETHUSD = 300.0
  @api_url = "https://api.coinmarketcap.com/v1/ticker/"

  def self.get_quotes()
    source = JSON.parse(open(@api_url).read)
    @BTCUSD = source.detect{|c| c["id"] == "bitcoin"}["price_usd"].to_f
    @ETHUSD = source.detect{|c| c["id"] == "ethereum"}["price_usd"].to_f
    puts "BTCUSD: #{@BTCUSD}"
    puts "ETHUSD: #{@ETHUSD}"
  end

  def self.btc_to_eth(amount)
    amount * (@BTCUSD) / (@ETHUSD)
  end

  def self.eth_to_btc(amount)
    amount * (@ETHUSD) / (@BTCUSD)
  end

  def self.btc_to_usd(amount)
    amount * (@BTCUSD)
  end

end