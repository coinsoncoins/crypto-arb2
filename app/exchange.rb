require './app/market'

class Exchange
  attr_reader :name, :markets, :client
  def initialize(name, client)
    @name = name
    @markets = []
    @client = client
  end

  def add_market(market)
    market.exchange = self
    @markets.push(market)
  end

  def get_market_like(market)
    @markets.detect { |c| c.name == market.name }
  end

  def has_market?(market)
    !get_market_like(market).nil?
  end

  def get_crypto_like(market)
    @markets.detect { |c| c.name.split('-')[0] == market.name.split('-')[0] }
  end

  def get_markets_with_crypto_(crypto_name)
    @markets.select { |c| c.crypto_name == crypto_name }
  end

end
