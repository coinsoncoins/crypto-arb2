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

    def to_usd(amount, base)
      if base == 'BTC'
        return btc_to_usd(amount)
      elsif base == 'ETH'
        return eth_to_usd(amount)
      else
        #raise StandardError.new("unsupported base: #{base}")
      end
    end
  end

end