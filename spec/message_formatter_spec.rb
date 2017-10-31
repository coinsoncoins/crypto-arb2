
require './app/arb_opp'
require './app/message_formatter'

RSpec.describe MessageFormatter do
  context "#format" do
    it do
      crypto1 = Market.new(exchange: Exchange.new('bittrex', nil), name: 'LTC-BTC', bid: 0.05090, ask: 0.06000, volume_24h: 1_000_000)
      crypto2 = Market.new(exchange: Exchange.new('hitbtc', nil), name: 'LTC-BTC', bid: 0.06060, ask: 0.06070, volume_24h: 2_000_000)
      arb_opp = ArbOpp.new(crypto1, crypto2)
      arb_opp.instance_variable_set(:@potential_profit, 600)
      arb_opp.instance_variable_set(:@amount_to_arb, 5000)
      message = MessageFormatter.arb_opp(arb_opp)
      expected_message = "Buy LTC-BTC at bittrex at ask 0.06000000 ($360.0) (volume 1000000.0) and sell LTC-BTC at hitbtc at bid 0.06060000 ($363.6) (volume 2000000.0) for gain 1.0%. potential profit=$600.00.  Buy 5000 coins"
      expect(message).to eq(expected_message)
    end
  end
end