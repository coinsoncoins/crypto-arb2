
require './app/arb_opp'
require './app/message_formatter'

RSpec.describe MessageFormatter do
  context "#format" do
    it do
      crypto1 = Crypto.new(exchange: Exchange.new('bittrex'), name: 'BTCUSD', bid: 5090, ask: 6000, volume_24h: 1_000_000)
      crypto2 = Crypto.new(exchange: Exchange.new('hitbtc'), name: 'BTCUSD', bid: 6060, ask: 6070, volume_24h: 2_000_000)
      arb_opp = ArbOpp.new(crypto1, crypto2)
      message = MessageFormatter.arb_opp(arb_opp)
      expected_message = "Buy BTCUSD at bittrex at ask 6000.00000000 (volume 1000000.0) and sell at hitbtc at bid 6060.00000000 (volume 2000000.0) for gain 1.0%"
      expect(message).to eq(expected_message)
    end
  end
end