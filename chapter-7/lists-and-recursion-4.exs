defmodule MyList do
  def span(from, to) when from > to, do: []
  def span(from, to), do: [ from | span(from+1, to) ]
end

IO.puts MyList.span(1, 10) # [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
