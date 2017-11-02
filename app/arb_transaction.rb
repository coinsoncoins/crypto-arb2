

class ArbTransaction
  attr_accessor :buy_at, :sell_at, :quantity, :profit, :total_profit
  def initialize(buy_at:, sell_at:, quantity:, profit:, total_profit:)
    @buy_at = buy_at
    @sell_at = sell_at
    @quantity = quantity
    @profit = profit
    @total_profit = total_profit
  end

  def to_s
    "buying #{quantity} at #{buy_at} and selling at #{sell_at} for profit #{profit} and total profit #{total_profit}"
  end
end