defmodule Parallel do
  def pmap(collection, fun) do
    me = self
    collection
    |> Enum.map(fn (elem) ->
        spawn_link fn -> (send me, { self, fun.(elem) }) end
      end)
    |> Enum.map(fn (pid) ->
        receive do { ^pid, result } -> result end
      end)
  end
end

IO.inspect Parallel.pmap 1..10, &(&1 * &1)

"""
$ elixir -r pmap.ex
[1, 4, 9, 16, 25, 36, 49, 64, 81, 100]

R: That variable is essential to have the list
in order, it is the PID of the spawn process.
The final Enum.map will receive a list of PIDs
is a certain order and that order is preserved
by pattern matching them with the return tuples
{ ^pid, result} from the previouly spawn processes.
"""

