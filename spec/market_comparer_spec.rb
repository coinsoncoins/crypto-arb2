
require './app/market_comparer'

RSpec.describe MarketComparer do
  context "#compare" do
    it "" do
      bittrex_market = {'BTCUSD': 5000, 'MTLBTC': 0.0001}
      binance_market = {'BTCUSD': 6000, 'MTLBTC': 0.0002}
      compare_results = MarketComparer.compare(bittrex_market, binance_market)
      expect(compare_results[0]).to eq({symbol: :MTLBTC, diff: 100.0})
      expect(compare_results[1]).to eq({symbol: :BTCUSD, diff: 20.0})

    end
  end
end