require './app/crypto_pair'

class Exchange
  attr_reader :name, :crypto_pairs
  def initialize(name)
    @name = name
    @crypto_pairs = []
  end

  def add_crypto_pair(crypto_pair)
    crypto_pair.exchange = self
    @crypto_pairs.push(crypto_pair)
  end

  def get_crypto_pair_like(crypto_pair)
    @crypto_pairs.detect { |c| c.name == crypto_pair.name }
  end

  def has_crypto_pair?(crypto_pair)
    !get_crypto_pair_like(crypto_pair).nil?
  end

end
