
require './app/hitbtc_client'

RSpec.describe HitBtcClient do
  context "#parse_snapshot" do
    it "parses" do
      hitbtc_client = HitBtcClient.new
      snapshot = open("./spec/data/hitbtc_api_call.json").read;
      markets = hitbtc_client.parse_snapshot(snapshot)
      expect(markets["BCNBTC"]).to eq(0.0000002504)
    end
  end
end