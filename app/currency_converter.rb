class CurrencyConverter
  
  def initialize()
    @btcusd = 6100.0
    @ethusd = 300.0
  end


  def btc_to_usd(btc)
    btc * @btcusd
  end

end