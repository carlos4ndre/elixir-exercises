defmodule Chop do
  def middle(min, max), do: div(min + max, 2)
  def guess(secret, rangeMin..rangeMax) when div(rangeMin + rangeMax, 2) > secret do
    IO.puts "It is #{middle(rangeMin, rangeMax)}"
    guess(secret, rangeMin..middle(rangeMin, rangeMax))
  end
  def guess(secret, rangeMin..rangeMax) when div(rangeMin + rangeMax, 2) < secret do
    IO.puts "It is #{middle(rangeMin, rangeMax)}"
    guess(secret, middle(rangeMin, rangeMax)..rangeMax)
  end
  def guess(secret, rangeMin..rangeMax), do: IO.puts middle(rangeMin, rangeMax)
end

IO.puts Chop.guess(273, 1..1000) # 273
