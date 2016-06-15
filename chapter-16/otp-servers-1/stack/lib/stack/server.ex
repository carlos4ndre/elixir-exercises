defmodule Stack.Server do
  use GenServer
  def handle_call(:pop, _from, [head|tail]) do
    {:reply, head, tail}
	end 
end

"""
$ iex -S mix
Erlang/OTP 18 [erts-7.0.3] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Compiled lib/stack/server.ex
Generated stack app
Interactive Elixir (1.0.5) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> { :ok, pid } = GenServer.start_link(Stack.Server, [1,2,3,4])
{:ok, #PID<0.94.0>}
iex(2)> GenServer.call(pid, :pop)
1
iex(3)> GenServer.call(pid, :pop)
2
iex(4)> GenServer.call(pid, :pop)
3
iex(5)> GenServer.call(pid, :pop)
4
iex(6)> GenServer.call(pid, :pop)
nil
"""
