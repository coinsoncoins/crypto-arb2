
require './app/crypto'

class ArbOpp
  attr_reader :crypto, :exchange1, :ask1, :volume_24h1, :exchange2, :bid2, :volume_24h2, :gain

  def initialize(crypto1, crypto2)
    @crypto1 = crypto1
    @crypto2 = crypto2
    @exchange1 = crypto1.exchange
    @ask1 = crypto1.ask
    @volume_24h1 = crypto1.volume_24h
    @exchange2 = crypto2.exchange
    @bid2 = crypto2.bid
    @volume_24h2 = crypto2.volume_24h
    @gain = (@bid2 - @ask1) / (@ask1)
  end

  def gain_percent
    @gain * 100.0
  end

  def crypto_name
    @crypto1.name
  end

  def valid?()
    @crypto1.valid? && @crypto2.valid?
  end

end