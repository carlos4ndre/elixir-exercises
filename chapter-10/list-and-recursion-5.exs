defmodule MyEnum do
  def all?([], _fun), do: true
  def all?([head | tail], fun) do
    if fun.(head), do: all?(tail, fun), else: false
  end

  def each([], _fun), do: :ok
  def each([head | tail], fun) do
    fun.(head)
    each(tail, fun)
  end

  def filter([], _fun), do: []
  def filter([head | tail], fun) do
    if fun.(head) do
      filter(tail, fun)
    else
      [ head | filter(tail, fun) ]
    end
  end

  def split(list, n) when n >= 0, do: _split(list, n, [])
  def split(list, n) when n < 0, do: _split(list, n + length(list), [])
  defp _split([head | tail], n, result) when length(result) < n do
    _split(tail, n, result ++ [head])
  end
  defp _split(list, _n, result), do: { result, list }

  def reverse([]), do: []
  def reverse([head | tail]), do: reverse(tail) ++ [head]

  def take(list, n) when n >= 0, do: _take(list, n, [])
  def take(list, n) when n < 0 do
    positive_index = abs(n)

    list
    |> reverse()
    |> _take(positive_index, [])
    |> reverse()
  end
  defp _take([head | tail], n, result) when length(result) < n do
    _take(tail, n, result ++ [head])
  end
  defp _take(_list, _n, result), do: result
end

IO.inspect MyEnum.all?([1,2,3,4], &(&1 > 0)) # true
IO.inspect MyEnum.all?([1,2,3,4], &(&1 > 2)) # false
IO.inspect MyEnum.all?([1,2,3,4], &(is_integer(&1))) # true
IO.inspect MyEnum.all?([1,2,3,4], &(is_boolean(&1))) # false

IO.inspect MyEnum.filter([1,2,3,4], &(&1 > 0)) # []
IO.inspect MyEnum.filter([1,2,3,4], &(&1 > 2)) # [1,2]
IO.inspect MyEnum.filter([1,2,"john",4], &(is_integer(&1))) # ["john"]
IO.inspect MyEnum.filter([1,true,false,4], &(is_boolean(&1))) # [1,4]

IO.inspect MyEnum.split([1,2,3,4], 2)  # {[1,2], [3,4]}
IO.inspect MyEnum.split([1,2,3,4], 10) # {[1,2,3,4], []}
IO.inspect MyEnum.split([1,2,3,4], 0)  # {[], [1,2,3,4]}
IO.inspect MyEnum.split([1,2,3,4], -1) # {[1,2,3], [4]}
IO.inspect MyEnum.split([1,2,3,4], -5) # {[], [1,2,3,4]}

IO.inspect MyEnum.reverse([])                       # []
IO.inspect MyEnum.reverse([1])                      # [1]
IO.inspect MyEnum.reverse([1, "two"])               # ["two",1]
IO.inspect MyEnum.reverse([1, "two", :three])       # [:three,"two,1]
IO.inspect MyEnum.reverse([1, "two", :three, 4.0])  # [4.0,:three,"two",1]

IO.inspect MyEnum.take([1,2,3,4], 2)  # [1,2]
IO.inspect MyEnum.take([1,2,3,4], 10) # [1,2,3,4]
IO.inspect MyEnum.take([1,2,3,4], 0)  # []
IO.inspect MyEnum.take([1,2,3,4], -1) # [4]
IO.inspect MyEnum.take([1,2,3,4], -5) # [1,2,3,4]

IO.inspect MyEnum.each(["john", "doe"], &(IO.puts &1))
# john
# doe
# :ok
