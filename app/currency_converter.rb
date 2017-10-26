require 'open-uri'
require 'json'
require './app/coinmarketcap_client'

class CurrencyConverter

  class << self
    attr_reader :BTCUSD, :ETHUSD

    def BTCUSD
      @BTCUSD ||= CoinMarketCapClient.get_price_usd('bitcoin')
    end

    def ETHUSD
      @ETHUSD ||= CoinMarketCapClient.get_price_usd('ethereum')
    end

    def btc_to_eth(amount)
      amount * self.BTCUSD / self.ETHUSD
    end

    def eth_to_btc(amount)
      amount * self.ETHUSD / self.BTCUSD
    end

    def btc_to_usd(amount)
      amount * self.BTCUSD
    end 

    def eth_to_usd(amount)
      amount * self.ETHUSD
    end
  end

end