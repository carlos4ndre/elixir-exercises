defmodule MyEnum do
  def flatten([]), do: []
  def flatten([head | last]) do
    if is_list(head) do
      flatten(head) ++ flatten(last)
    else
      [head] ++ flatten(last)
    end
  end
end

IO.inspect MyEnum.flatten([1,[2,3,[4]],5,[[[6]]]]) # [1,2,3,4,5,6]
