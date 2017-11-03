

class ArbTransaction
  attr_accessor :buy_at, :sell_at, :buy_at_usd, :sell_at_usd, :quantity, :profit, :total_profit
  def initialize(buy_at:, buy_at_usd:, sell_at:, sell_at_usd:, quantity:, profit:, total_profit:)
    @buy_at = buy_at
    @buy_at_usd = buy_at_usd
    @sell_at = sell_at
    @sell_at_usd = sell_at_usd
    @quantity = quantity
    @profit = profit
    @total_profit = total_profit
  end

  def to_s
    "buying #{quantity} at #{'%.8f' % buy_at} ($#{buy_at_usd}) and selling at #{'%.8f' % sell_at} ($#{sell_at_usd}) for profit #{profit} and total profit #{total_profit}"
  end
end