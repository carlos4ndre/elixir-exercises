defmodule Calc do
  def sum(1), do: 1
  def sum(n), do: n + sum(n-1)
end

IO.puts Calc.sum(1) # 1
IO.puts Calc.sum(2) # 3
IO.puts Calc.sum(3) # 6
IO.puts Calc.sum(4) # 10
IO.puts Calc.sum(5) # 15
