defmodule MyList do
  def span(from, to) when from > to, do: []
  def span(from, to), do: [ from | span(from+1, to) ]
end

n = 10
IO.inspect for x <- MyList.span(2,n), Enum.all?(MyList.span(2,x-1), &(rem(x,&1)!=0)), do: x # [2,3,5,7]
n = 20
IO.inspect for x <- MyList.span(2,n), Enum.all?(MyList.span(2,x-1), &(rem(x,&1)!=0)), do: x # [2,3,5,7,11,13,17,19]
