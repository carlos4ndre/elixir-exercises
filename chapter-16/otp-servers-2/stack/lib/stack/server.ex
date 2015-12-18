defmodule Stack.Server do
  use GenServer

  def handle_call(:pop, _from, current_stack) do
    first_element = List.first(current_stack)
    new_list = List.delete_at(current_stack, 0)

    { :reply, first_element, new_list }
  end

  def handle_cast({:push, new_element}, current_stack) do
    new_list = List.insert_at(current_stack, 0, new_element)

    { :noreply, new_list }
  end
end

"""
$ iex -S mix
Erlang/OTP 18 [erts-7.0.3] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Compiled lib/stack/server.ex
Generated stack app
Interactive Elixir (1.0.5) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> { :ok, pid } = GenServer.start_link(Stack.Server, [])
{:ok, #PID<0.95.0>}
iex(2)> GenServer.call(pid, :pop)
nil
iex(3)> GenServer.cast(pid, {:push, "Heavy Metal"})
:ok
iex(4)> GenServer.cast(pid, {:push, :"CAt Metal"})
:ok
iex(5)> GenServer.cast(pid, {:push, 1234})
:ok
iex(6)> GenServer.cast(pid, {:push, ["Just", "Another", "List"]})
:ok
iex(7)> GenServer.call(pid, :pop)
["Just", "Another", "List"]
iex(8)> GenServer.call(pid, :pop)
1234
iex(9)> GenServer.call(pid, :pop)
:"CAt Metal"
iex(10)> GenServer.call(pid, :pop)
"Heavy Metal"
iex(11)> GenServer.call(pid, :pop)
nil
"""
