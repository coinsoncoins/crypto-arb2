
require './app/bittrex_client'

RSpec.describe BittrexClient do
  context "#parse_snapshot" do
    it "parses" do
      bittrex_client = BittrexClient.new
      snapshot = open("./spec/data/bittrex_api_call.json").read;
      markets = bittrex_client.parse_snapshot(snapshot)
      expect(markets["1STBTC"]).to eq(0.00004186)
    end
  end
end