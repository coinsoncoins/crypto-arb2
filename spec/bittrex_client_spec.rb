
require './app/bittrex_client'

RSpec.describe BittrexClient do
  context "#parse_snapshot" do
    it "parses" do
      bittrex_client = BittrexClient.new
      snapshot = open("./spec/data/bittrex_api_call.json").read;
      markets = bittrex_client.parse_snapshot(snapshot)
      expect(markets["1STBTC"]).to eq({
        bid: 0.00004186,
        ask: 0.00004188,
        volume: 33.70546702
      })
    end
  end
end