require './app/crypto'

class Exchange
  attr_reader :name, :cryptos
  def initialize(name)
    @name = name
    @cryptos = []
  end

  def add_crypto(crypto)
    crypto.exchange = self
    @cryptos.push(crypto)
  end

  def get_crypto_like(crypto)
    @cryptos.detect { |c| c.name == crypto.name }
  end

  def has_crypto?(crypto)
    !get_crypto_like(crypto).nil?
  end

end
