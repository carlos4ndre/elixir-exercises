defmodule Stack.Server do
  use GenServer

  ###############
  # External API
  ###############

  def start_link(current_stack) do
    GenServer.start_link(__MODULE__, current_stack, name: __MODULE__)
  end

  def pop do
    GenServer.call(__MODULE__, :pop)
  end

  def push(element) do
    GenServer.cast(__MODULE__, {:push, element})
  end

  ###########################
  # GenServer Implementation
  ###########################

  def handle_call(:pop, _from, current_stack) do
    first_element = List.first(current_stack)
    new_list = List.delete_at(current_stack, 0)

    { :reply, first_element, new_list }
  end

  def handle_cast({:push, new_element}, current_stack) do
    new_list = List.insert_at(current_stack, 0, new_element)

    { :noreply, new_list }
  end

  def format_status(_reason, [ _pdict, state ]) do
    [data: [{'State', "My current state is '#{inspect state}'"}]]
  end
end

"""
$ iex -S mix
Erlang/OTP 18 [erts-7.0.3] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Compiled lib/stack/server.ex
Generated stack app
Interactive Elixir (1.0.5) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Stack.Server.start_link [1,2]
{:ok, #PID<0.94.0>}
iex(2)> Stack.Server.push 3
:ok
iex(3)> Stack.Server.push 4
:ok
iex(4)> Stack.Server.pop
4
iex(5)> Stack.Server.pop
3
iex(6)> Stack.Server.pop
1
iex(7)> Stack.Server.pop
2
iex(8)> Stack.Server.pop
nil
"""
