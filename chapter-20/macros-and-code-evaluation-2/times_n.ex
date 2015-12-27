defmodule Times do
  defmacro times_n(x) do
    quote do
      def unquote(:"times_#{x}")(value) do
        unquote(x) * value
      end
    end
  end
end

defmodule Test do
  require Times
  Times.times_n(3)
  Times.times_n(4)
end

IO.puts Test.times_3(4)
IO.puts Test.times_4(5)

"""
$ elixir -r Times.ex
12
20
"""
