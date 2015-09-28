defmodule MyCalculator do
  def calculate(list), do: _calculate(list, 0)

  defp _calculate([ ?/ | tail], num1), do: num1 / _calculate(tail, 0)
  defp _calculate([ ?* | tail], num1), do: num1 * _calculate(tail, 0)
  defp _calculate([ ?+ | tail], num1), do: num1 + _calculate(tail, 0)
  defp _calculate([ ?- | tail], num1), do: num1 - _calculate(tail, 0)
  defp _calculate([ digit | tail], num)  when digit in ' ' do # ignore whitespaces
    _calculate(tail, num)
  end
  defp _calculate([ digit | tail], num) when digit in '0123456789' do
    _calculate(tail, num * 10 + digit - ?0)
  end
  defp _calculate([], num2), do: num2
  defp _calculate(_,_), do: raise "Invalid operation"
end

IO.inspect MyCalculator.calculate('1 + 50'); # 51
IO.inspect MyCalculator.calculate('1 - 50'); # -49
IO.inspect MyCalculator.calculate('1 * 50'); # 50
IO.inspect MyCalculator.calculate('1 / 50'); # 0.02
IO.inspect MyCalculator.calculate('100 + 50'); # 150
IO.inspect MyCalculator.calculate('100 - 50'); # 50
IO.inspect MyCalculator.calculate('100 * 50'); # 5000
IO.inspect MyCalculator.calculate('100 / 50'); # 2.0
IO.inspect MyCalculator.calculate('100 . 50'); # Invalid Operation
