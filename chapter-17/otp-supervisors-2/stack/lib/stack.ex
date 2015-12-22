defmodule Stack do
  use Application

  @initial_state [1,2,3,4]

  def start(_type, _args) do
    {:ok, _pid} = Stack.Supervisor.start_link(@initial_state)
  end
end

"""
$ iex -S mix
Erlang/OTP 18 [erts-7.0.3] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Interactive Elixir (1.0.5) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Stack.Server.push 10
:ok
iex(2)> Stack.Server.push 20
:ok
iex(3)> Stack.Server.push 30
:ok
iex(4)> Stack.Server.push 40
:ok
iex(5)> Stack.Server.push "Ash Vs Evil Dead"
:ok
iex(6)>
18:30:18.587 [error] GenServer Stack.Server terminating
Last message: {:"$gen_cast", {:push, "Ash Vs Evil Dead"}}
State: [data: [{'State', "My current state is '{[40, 30, 20, 10, 1, 2, 3, 4], #PID<0.86.0>}'"}]]
** (exit) an exception was raised:
    ** (RuntimeError) Invalid Operation: element must be a valid number
        (stack) lib/stack/server.ex:39: Stack.Server.handle_cast/2
        (stdlib) gen_server.erl:615: :gen_server.try_dispatch/4
        (stdlib) gen_server.erl:681: :gen_server.handle_msg/5
        (stdlib) proc_lib.erl:239: :proc_lib.init_p_do_apply/3

nil
iex(7)> Stack.Server.pop
40
iex(8)> Stack.Server.pop
30
iex(9)> Stack.Server.pop
20
iex(10)> Stack.Server.pop
10
"""
