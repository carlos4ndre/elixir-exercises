defmodule LineSigil do
  def sigil_v(content, _opts) do
    lines = String.split(content,"\n", trim: true)
    column_names = get_column_names(lines)
    remaining_lines = get_remaining_lines(lines)

    remaining_lines
    |> Enum.map(&parse_line/1)
    |> Enum.map(&add_column_names_to_line(&1, column_names))
  end

  defp get_column_names(lines) do
    lines
    |> Enum.at(0)
    |> String.split(",")
    |> Enum.map &(String.to_atom/1)
  end

  defp get_remaining_lines(lines) do
    {_column_names, remaining_lines} = Enum.split(lines, 1)
    remaining_lines
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

  defp add_column_names_to_line(line, column_names) do
    Enum.zip(column_names, line)
  end
end

defmodule Example do
  import LineSigil

  def csv do
    ~v"""
    Item,Qty,Price
    Teddy bear,4,34.95
    Milk,1,2.99
    Battery,6,8.00
    """
  end
end

IO.inspect Example.csv

"""
$ elixir -r line-sigil.exs
[[Item: "Teddy bear", Qty: 4.0, Price: 34.95],
 [Item: "Milk", Qty: 1.0, Price: 2.99], [Item: "Battery", Qty: 6.0, Price: 8.0]]
"""
