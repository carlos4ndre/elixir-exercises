defprotocol Enumerable do
  def count(collection)
  def member?(collection, value)
  def reduce(collection, acc, fun)
end

defprotocol Inspect do
  def inspect(value, opts)
end

defmodule Bitmap do
  defstruct value: 0

  defimpl Enumerable, for: Bitmap do
    import :math, only: [log: 1]

    def count(%Bitmap{value: value}) do
      { :ok, trunc(log(abs(value))/log(2)) + 1 }
    end

    def member?(value, bit_number) do
      { :ok, 0 <= bit_number && bit_number < Enum.count(value) }
    end

    def reduce(bitmap, {:cont, acc}, fun) do
      bit_count = Enum.count(bitmap)
      _reduce({bitmap, bit_count}, {:cont, acc}, fun)
    end

    defp _reduce({_bitmap, -1}, {:cont, acc}, _fun), do: {:done, acc}

    defp _reduce({bitmap, bit_number}, {:cont, acc}, fun) do
      value = Integer.digits(bitmap.value, 2)
      _reduce({bitmap, bit_number-1}, fun.(Enum.at(value, bit_number-1), acc), fun)
    end

    defp _reduce({_bitmap, _bit_number}, {:halt, acc}, _fun), do: {:halted, acc}

    defp _reduce({bitmap, bit_number}, {:suspend, acc}, fun) do
      {:suspended, acc, &_reduce({bitmap, bit_number}, &1, fun), fun}
    end
  end

  defimpl Inspect, for: Bitmap do
    import Inspect.Algebra
    def inspect(%Bitmap{value: value}, _opts) do
      concat([
        nest(
          concat([
            "%Bitmap{",
            break(""),
            nest(concat(["value:",
                         break(""),
                         to_string(value)]),
                2),
          ]), 2),
          break(""),
          "}"])
    end
  end
end

defmodule MyTest do
  def run do
    fifty = %Bitmap{value: 50}
    IO.inspect fifty # %Bitmap{value:50}
  end
end

MyTest.run
