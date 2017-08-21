tax_rates = [NC: 0.075, TX: 0.08]
orders = [
  [id: 123, ship_to: :NC, net_amount: 100.00],
  [id: 124, ship_to: :OK, net_amount:  35.50],
  [id: 125, ship_to: :TX, net_amount:  24.00],
  [id: 126, ship_to: :TX, net_amount:  44.80],
  [id: 127, ship_to: :NC, net_amount:  25.00],
  [id: 128, ship_to: :MA, net_amount:  10.00],
  [id: 129, ship_to: :CA, net_amount: 102.00],
  [id: 130, ship_to: :NC, net_amount:  50.00],
]

defmodule DaveStore do

  def buy(orders, tax_rates) do
    for order <- orders do
      net_amount = order[:net_amount]
      ship_to = order[:ship_to]
      tax_rate = calculate_tax_rate(ship_to, tax_rates)
      total_amount = calculate_total_amount(net_amount, tax_rate)

      order ++ [total_amount: total_amount]
    end
  end

  defp calculate_tax_rate(ship_to, tax_rates) do
    Keyword.get(tax_rates, ship_to, 0.0)
  end

  defp calculate_total_amount(net_amount, tax_rate), do: net_amount + net_amount * tax_rate
end

IO.inspect DaveStore.buy(orders, tax_rates)
#[[id: 123, ship_to: :NC, net_amount: 100.0, total_amount: 107.5],
# [id: 124, ship_to: :OK, net_amount: 35.5, total_amount: 35.5],
# [id: 125, ship_to: :TX, net_amount: 24.0, total_amount: 25.92],
# [id: 126, ship_to: :TX, net_amount: 44.8, total_amount: 48.384],
# [id: 127, ship_to: :NC, net_amount: 25.0, total_amount: 26.875],
# [id: 128, ship_to: :MA, net_amount: 10.0, total_amount: 10.0],
# [id: 129, ship_to: :CA, net_amount: 102.0, total_amount: 102.0],
# [id: 130, ship_to: :NC, net_amount: 50.0, total_amount: 53.75]]
