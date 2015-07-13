defmodule MyList do
  def caesar([], _n), do: []
  def caesar([ head | tail ], n) when head + n < 122 do
    [ head + n | caesar(tail, n) ]
  end
  def caesar([_head | tail], n) do
    [ '?' | caesar(tail, n) ]
  end
end

IO.puts MyList.caesar('ryvkve', 13) # ???x?r
