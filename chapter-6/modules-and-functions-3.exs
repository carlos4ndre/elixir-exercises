defmodule Times do
  def double(n), do: n * 2
  def triple(n), do: n * 3
  def quadruple(n), do: double(n) * 2
end

IO.puts Times.quadruple(1) # 4
IO.puts Times.quadruple(2) # 8
IO.puts Times.quadruple(3) # 12
