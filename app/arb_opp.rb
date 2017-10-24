
require './app/crypto_pair'

class ArbOpp
  attr_reader :crypto_pair1, :crypto_pair2, :exchange1, :ask1, :volume_24h1, :exchange2, :bid2, :volume_24h2,
    :gain, :potential_profit

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

  def calc_potential_profit
    book1 = @crypto_pair1.exchange.client.get_order_book(@crypto_pair1)
    book2 = @crypto_pair2.exchange.client.get_order_book(@crypto_pair2)
    @potential_profit = book1.arb_order_books(book2)
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