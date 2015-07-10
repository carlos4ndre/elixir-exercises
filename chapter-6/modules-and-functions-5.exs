defmodule Calc do
  def gcd(x,0), do: x
  def gcd(x,y), do: gcd(y,rem(x,y))
end

IO.puts Calc.gcd(1,12) # 1
IO.puts Calc.gcd(2,12) # 2
IO.puts Calc.gcd(3,12) # 3
IO.puts Calc.gcd(4,12) # 4
IO.puts Calc.gcd(5,12) # 1
IO.puts Calc.gcd(6,12) # 6
IO.puts Calc.gcd(7,12) # 1
IO.puts Calc.gcd(8,12) # 4
IO.puts Calc.gcd(9,12) # 3
IO.puts Calc.gcd(10,12) # 2
