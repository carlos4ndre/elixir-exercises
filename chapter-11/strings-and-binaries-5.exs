defmodule MyWordUtils do
  defp get_max_width(list), do: Enum.max(Enum.map(list, &(String.length(&1))))

  def center(list), do: _center(list, get_max_width(list), [])
  defp _center([word | tail], max_width, result) do
    _center(
      tail,
      max_width,
      result ++ [String.rjust(
                  word,
                  div(max_width + String.length(word), 2),
                  ?\s)])
  end
  defp _center([], _, result), do: IO.puts Enum.join(result, "\n")
end

IO.puts MyWordUtils.center(["cat", "zebra", "elephant"])
IO.puts MyWordUtils.center(["Buckethead", "Tool", "Children Of Bodom"])
IO.puts MyWordUtils.center(["A", "long time ago", "in a galaxy far, far away..."])
