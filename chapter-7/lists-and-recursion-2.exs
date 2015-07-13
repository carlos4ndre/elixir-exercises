defmodule MyList do
  def max([ head | tail ]), do: _max(tail, head)

  defp _max([], maximum), do: maximum
  defp _max([ head | tail ], maximum) when head > maximum do
    _max(tail, head)
  end
  defp _max([_head | tail ], maximum), do: _max(tail, maximum)
end

IO.puts MyList.max [1,4,5,4]  # 5
IO.puts MyList.max [1,10,5,2] # 10
IO.puts MyList.max [9,2,5,4]  # 9
IO.puts MyList.max [2,2,2,2]  # 2
