class CurrencyConverter

  class << self
    attr_accessor :BTCUSD
  end

  @BTCUSD = 6000
  @ETHUSD = 300

  #attr_accessor :BTCUSD

  def initialize()
  end

  def btc_to_usd(btc)
    btc * @btcusd
  end

end