defmodule LineSigil do
  def sigil_v(lines, _opts) do
    lines
    |> String.split("\n", trim: true)
    |> Enum.map &(String.split(&1,","))
  end
end

defmodule Example do
  import LineSigil

  def csv do
    ~v"""
    1,2,3
    cat,dog
    """
  end
end

IO.inspect Example.csv

"""
$ elixir -r line-sigil.exs
[["1", "2", "3"], ["cat", "dog"]]
"""
