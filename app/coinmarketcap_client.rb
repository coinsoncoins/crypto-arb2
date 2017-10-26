
require 'open-uri'

class CoinMarketCapClient
  class << self
    def url
      "https://api.coinmarketcap.com/v1/ticker/"
    end

    def data
      @data ||= JSON.parse(open(url).read)
    end

    def get_price_usd(crypto_name)
      data.detect{|c| c["id"] == crypto_name}["price_usd"].to_f
    end
  end
end
