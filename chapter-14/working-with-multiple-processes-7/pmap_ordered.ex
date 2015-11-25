defmodule Parallel do
  import :timer, only: [ sleep: 1 ]

  def pmap(collection, fun) do
    total_size = Enum.count(collection)
    me = self

    collection
    |> Enum.with_index
    |> Enum.map(fn ({index, value}) ->
        waiting_time = (total_size - index) * 1000
        IO.puts "Process ##{index} with value #{value} is going to wait for #{waiting_time} ms"
        spawn_link fn -> (
          sleep(waiting_time)
          sleep(value)
          send me, { self, fun.(value) }
        ) end
      end)
    |> Enum.map(fn (pid) ->
        receive do { _pid, result } -> result end
      end)
  end
end

IO.inspect Parallel.pmap 1..10, &(&1 * &1)

"""
$ elixir -r pmap_ordered.ex
Process #1 with value 0 is going to wait for 9000 ms
Process #2 with value 1 is going to wait for 8000 ms
Process #3 with value 2 is going to wait for 7000 ms
Process #4 with value 3 is going to wait for 6000 ms
Process #5 with value 4 is going to wait for 5000 ms
Process #6 with value 5 is going to wait for 4000 ms
Process #7 with value 6 is going to wait for 3000 ms
Process #8 with value 7 is going to wait for 2000 ms
Process #9 with value 8 is going to wait for 1000 ms
Process #10 with value 9 is going to wait for 0 ms
[0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
"""
