class Market

  attr_accessor :name, :bid, :ask, :exchange, :order_book, :id, :token_addr
  attr_accessor :volume_24h # volume is denominated in base currency
  def initialize(name:, bid: nil, ask: nil, volume_24h: nil, exchange: nil, id: nil, token_addr: nil)
    @name = name
    @bid = bid.to_f
    @ask = ask.to_f
    @volume_24h = volume_24h.to_f
    @exchange = exchange
    @id = id.to_i
    @token_addr = token_addr
  end

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
    base = /BTC$|ETC$|LTC$|EUR$|USD$|USTD$/.match(name).to_s
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
