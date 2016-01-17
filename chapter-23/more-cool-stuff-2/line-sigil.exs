defmodule LineSigil do
  def sigil_v(lines, _opts) do
    lines
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.split(",")
    |> Enum.map(&parse_cell/1)
  end

  defp parse_cell(value) do
    case Float.parse(value) do
      {num, ""} -> num
      {num, _r} -> num
      :error    -> value
    end
  end
end

defmodule Example do
  import LineSigil

  def csv do
    ~v"""
    1,2,3.14
    cat,dog
    """
  end
end

IO.inspect Example.csv

"""
$ elixir -r line-sigil.exs
[[1.0, 2.0, 3.14], ["cat", "dog"]]
"""
