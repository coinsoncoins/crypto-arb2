
require './app/exchange_compare_results_formatter'

RSpec.describe ExchangeCompareResultsFormatter do
  context "#format" do
    it do
      result = OpenStruct.new(
        market: 'BTCUSD',
        exchange1: 'bittrex',
        ask1: 6000,
        volume1: 1_000_000,
        exchange2: 'hitbtc',
        bid2: 6060,
        volume2: 2_000_000,
        gain: 0.01
      )
      message = ExchangeCompareResultsFormatter.format(result)
      expected_message = "Buy BTCUSD at bittrex at ask 6000 (volume 1000000) and sell at hitbtc at bid 6060 (volume 2000000) for gain 1%"
      expect(message).to eq(expected_message)
    end
  end
end