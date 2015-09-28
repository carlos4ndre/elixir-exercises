defmodule OrderStore do
  def fetch_all() do
    file = File.open!("orders.csv", [:read, :utf8])
    headers = process_headers(IO.read(file, :line))
    process_rows(file, headers)
  end

  defp process_headers(data) do
    String.split(data, ",") # split header values
    |> Enum.map(&(String.strip(&1))) # remove '\n'
    |> Enum.map(&(String.to_atom(&1))) # convert to atom
  end

  defp process_rows(file, headers) do
    Enum.map IO.stream(file, :line), fn(row) ->
        process_row(headers, row)
    end
  end

  defp process_row(headers, data) do
    values = String.split(data, ",") # split row values
    |> Enum.map(&(String.strip(&1))) # remove '\n'
    |> Enum.map(&(process_value(&1))) # handles different data types
    Enum.zip(headers, values)
  end

  defp process_value(str) do
    case Float.parse(str) do
      {num, _} -> num
      :error   -> String.to_atom(String.lstrip(str, ?:))
    end
  end
end

defmodule DaveStore do
  def buy(orders, tax_rates) do
    for o <- orders do
      if Enum.any?([ :NC, :TX ], &(&1 == o[:ship_to])) do
        o ++ [total_amount: o[:net_amount] + o[:net_amount] * tax_rates[o[:ship_to]]]
      else
        o ++ [total_amount: o[:net_amount]]
      end
    end
  end
end

tax_rates = [ NC: 0.075, TX: 0.08 ]
orders = OrderStore.fetch_all()

IO.puts DaveStore.buy(orders, tax_rates)
#[[id: 123, ship_to: :NC, net_amount: 100.0, total_amount: 107.5],
# [id: 124, ship_to: :OK, net_amount: 35.5, total_amount: 35.5],
# [id: 125, ship_to: :TX, net_amount: 24.0, total_amount: 25.92],
# [id: 126, ship_to: :TX, net_amount: 44.8, total_amount: 48.384],
# [id: 127, ship_to: :NC, net_amount: 25.0, total_amount: 26.875],
# [id: 128, ship_to: :MA, net_amount: 10.0, total_amount: 10.0],
# [id: 129, ship_to: :CA, net_amount: 102.0, total_amount: 102.0],
# [id: 130, ship_to: :NC, net_amount: 50.0, total_amount: 53.75]]
