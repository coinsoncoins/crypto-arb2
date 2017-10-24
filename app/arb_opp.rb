
require './app/crypto_pair'

class ArbOpp
  attr_reader :crypto_pair1, :crypto_pair2, :exchange1, :ask1, :volume_24h1, :exchange2, :bid2, :volume_24h2, :gain

  def initialize(crypto_pair1, crypto_pair2)
    @crypto_pair1 = crypto_pair1
    @crypto_pair2 = crypto_pair2
    @exchange1 = crypto_pair1.exchange
    @ask1 = crypto_pair1.ask
    @volume_24h1 = crypto_pair1.volume_24h
    @exchange2 = crypto_pair2.exchange
    @bid2 = crypto_pair2.bid
    @volume_24h2 = crypto_pair2.volume_24h
    @gain = (@bid2 - @ask1) / (@ask1)
  end

  def get_potential_profit

  end

  def gain_percent
    @gain * 100.0
  end

  def crypto_name
    @crypto_pair1.name
  end

  def valid?()
    @crypto_pair1.valid? && @crypto_pair2.valid?
  end

end