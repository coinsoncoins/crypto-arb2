
require './app/arb_opp'
require './app/message_formatter'

RSpec.describe MessageFormatter do
  context "#format" do
    it do
      crypto1 = Market.new(exchange: Exchange.new('bittrex', nil), name: 'BTCUSD', bid: 5090, ask: 6000, volume_24h: 1_000_000)
      crypto2 = Market.new(exchange: Exchange.new('hitbtc', nil), name: 'BTCUSD', bid: 6060, ask: 6070, volume_24h: 2_000_000)
      arb_opp = ArbOpp.new(crypto1, crypto2)
      arb_opp.instance_variable_set(:@potential_profit, 0.001)
      message = MessageFormatter.arb_opp(arb_opp)
      expected_message = "Buy BTCUSD at bittrex at ask 6000.00000000 (volume 1000000.0) and sell at hitbtc at bid 6060.00000000 (volume 2000000.0) for gain 1.0%. potential profit=0.00100000 BTC ($6)"
      expect(message).to eq(expected_message)
    end
  end
end