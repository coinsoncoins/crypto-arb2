
require './app/arb_opp'


RSpec.describe ArbOpp do
  context "#get_exchange" do
    it do
      crypto_pair1 = CryptoPair.new(name: 'BNT-BTC')
      crypto_pair2 = CryptoPair.new(name: 'BNT-BTC')

      arb_opp = ArbOpp.new(crypto_pair1, crypto_pair2)
      #arb_opp.calc_potential_profit
    end
  end
end
