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

  def handle_call(:pop, _from, current_stack) when length(current_stack) == 0 do
    raise "Invalid Operation: pop on empty stack"
  end

  def handle_call(:pop, _from, current_stack) do
    first_element = List.first(current_stack)
    new_list = List.delete_at(current_stack, 0)

    { :reply, first_element, new_list }
  end

  def handle_cast({:push, new_element}, current_stack) when not is_number(new_element) do
    raise "Invalid Operation: element must be a valid number"
  end

  def handle_cast({:push, new_element}, current_stack) do
    new_list = List.insert_at(current_stack, 0, new_element)

    { :noreply, new_list }
  end

  def terminate(reason, state) do
    IO.puts("reason: #{inspect reason}\n
             state: #{inspect state}")
  end

  def format_status(_reason, [ _pdict, state ]) do
    [data: [{'State', "My current state is '#{inspect state}'"}]]
  end
end

"""
$ iex -S mix
Erlang/OTP 18 [erts-7.0.3] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Compiled lib/stack.ex
Generated stack app
Interactive Elixir (1.0.5) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Stack.Server.pop
1
iex(2)> Stack.Server.pop
2
iex(3)> Stack.Server.pop
3
iex(4)> Stack.Server.pop
4
iex(5)> Stack.Server.pop
reason: {%RuntimeError{message: "Invalid Operation: pop on empty stack"}, [{Stack.Server, :handle_call, 3, [file: 'lib/stack/server.ex', line: 25]}, {:gen_server, :try_handle_call, 4, [file: 'gen_server.erl', line: 629]}, {:gen_server, :handle_msg, 5, [file: 'gen_server.erl', line: 661]}, {:proc_lib, :init_p_do_apply, 3, [file: 'proc_lib.erl', line: 239]}]}

             state: []
** (exit) exited in: GenServer.call(Stack.Server, :pop, 5000)
    ** (EXIT) an exception was raised:
        ** (RuntimeError) Invalid Operation: pop on empty stack
            (stack) lib/stack/server.ex:25: Stack.Server.handle_call/3
            (stdlib) gen_server.erl:629: :gen_server.try_handle_call/4
            (stdlib) gen_server.erl:661: :gen_server.handle_msg/5
            (stdlib) proc_lib.erl:239: :proc_lib.init_p_do_apply/3

21:28:53.586 [error] GenServer Stack.Server terminating
Last message: :pop
State: [data: [{'State', "My current state is '[]'"}]]
** (exit) an exception was raised:
    ** (RuntimeError) Invalid Operation: pop on empty stack
        (stack) lib/stack/server.ex:25: Stack.Server.handle_call/3
        (stdlib) gen_server.erl:629: :gen_server.try_handle_call/4
        (stdlib) gen_server.erl:661: :gen_server.handle_msg/5
        (stdlib) proc_lib.erl:239: :proc_lib.init_p_do_apply/3
    (elixir) lib/gen_server.ex:356: GenServer.call/3
iex(5)> Stack.Server.pop
1
iex(6)> Stack.Server.pop
2
iex(7)> Stack.Server.pop
3
iex(8)> Stack.Server.pop
4
iex(9)> Stack.Server.pop
reason: {%RuntimeError{message: "Invalid Operation: pop on empty stack"}, [{Stack.Server, :handle_call, 3, [file: 'lib/stack/server.ex', line: 25]}, {:gen_server, :try_handle_call, 4, [file: 'gen_server.erl', line: 629]}, {:gen_server, :handle_msg, 5, [file: 'gen_server.erl', line: 661]}, {:proc_lib, :init_p_do_apply, 3, [file: 'proc_lib.erl', line: 239]}]}

             state: []
** (exit) exited in: GenServer.call(Stack.Server, :pop, 5000)
    ** (EXIT) an exception was raised:
        ** (RuntimeError) Invalid Operation: pop on empty stack
            (stack) lib/stack/server.ex:25: Stack.Server.handle_call/3
            (stdlib) gen_server.erl:629: :gen_server.try_handle_call/4
            (stdlib) gen_server.erl:661: :gen_server.handle_msg/5
            (stdlib) proc_lib.erl:239: :proc_lib.init_p_do_apply/3

21:29:02.919 [error] GenServer Stack.Server terminating
Last message: :pop
State: [data: [{'State', "My current state is '[]'"}]]
** (exit) an exception was raised:
    ** (RuntimeError) Invalid Operation: pop on empty stack
        (stack) lib/stack/server.ex:25: Stack.Server.handle_call/3
        (stdlib) gen_server.erl:629: :gen_server.try_handle_call/4
        (stdlib) gen_server.erl:661: :gen_server.handle_msg/5
        (stdlib) proc_lib.erl:239: :proc_lib.init_p_do_apply/3
    (elixir) lib/gen_server.ex:356: GenServer.call/3
iex(9)>
"""
