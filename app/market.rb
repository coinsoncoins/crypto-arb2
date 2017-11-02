
require './app/currency_converter'

class BadMarketNameError < StandardError
  attr_reader :name
  def initialize(message, name)
    @name = name
    super(message)
  end
end


class Market

  attr_accessor :name, :bid, :ask, :exchange, :order_book, :id, :token_addr, :bid_usd, :ask_usd
  attr_accessor :volume_24h # volume is denominated in base currency
  def initialize(name:, bid: nil, ask: nil, volume_24h: nil, exchange: nil, id: nil, token_addr: nil)
    @name = name
    @bid = bid.to_f
    @bid_usd = CurrencyConverter.to_usd(@bid, base)
    @ask = ask.to_f
    @ask_usd = CurrencyConverter.to_usd(@ask, base)
    @volume_24h = volume_24h.to_f
    @exchange = exchange
    @id = id.to_i
    @token_addr = token_addr
    if crypto.to_s.strip.empty? || base.to_s.strip.empty?
      raise BadMarketNameError.new("Poorly formatted Market name: #{@name}", @name)
    end
  end

  # def bid
  #   @bid
  # end

  # def bid=(value)
  # end

  def valid?()
    @bid > 0.00000001 && @ask > 0.00000001
  end

  # def eql?(other)
  #   @name == other.name && 
  #   @bid == other.bid &&
  #   @ask == other.ask &&
  #   @volume_24h = other.volume_24h
  #   @exchange = other.exchange
  # end

  def self.parse_base(name)
    base = /BTC$|ETH$|LTC$|EUR$|CAD$|GBP$|JPY$|USD$|USTD$|USDT$/.match(name).to_s
    if base.to_s.strip.empty?
      raise BadMarketNameError.new("Poorly formatted Market name: #{name}", name)
    end
    crypto = name.sub(base, '')
    [crypto, base]
  end

  def crypto
    @name.split('-')[0]
  end

  def base
    @name.split('-')[1]
  end

  def get_order_book
    @order_book ||= exchange.client.get_order_book(self)
  end

end
