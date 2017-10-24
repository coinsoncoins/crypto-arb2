require './app/crypto_pair'

class Exchange
  attr_reader :name, :cryptos
  def initialize(name)
    @name = name
    @cryptos = []
  end

  def add_crypto_pair(crypto)
    crypto.exchange = self
    @cryptos.push(crypto)

    # if has an ETH market, make a BTC market one for comparison (hack)
    # if crypto.name.end_with?('ETH')
    #   name = crypto.name.sub(/ETH$/, "BTC")
    #   crypto2 = CryptoPair.new(name: name, exchange: crypto.exchange)
    #   crypto2.bid = CurrencyConverter.eth_to_btc(crypto.bid)
    #   crypto2.ask = CurrencyConverter.eth_to_btc(crypto.ask)
    #   crypto2.volume_24h = CurrencyConverter.eth_to_btc(crypto.volume_24h)
    #   crypto2.eth_proxy = true
    #   @cryptos.push(crypto)
    # end
  end

  def get_crypto_pair_like(crypto_pair)
    @cryptos.detect { |c| c.name == crypto_pair.name }
  end

  def has_crypto_pair?(crypto_pair)
    !get_crypto_pair_like(crypto_pair).nil?
  end

end
