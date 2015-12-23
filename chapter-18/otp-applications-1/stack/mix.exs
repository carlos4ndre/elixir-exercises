defmodule Stack.Mixfile do
  use Mix.Project

  @initial_state [1,2,3,4]

  def project do
    [app: :stack,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      applications: [:logger],
      mod: { Stack, [] },
      env: [initial_state: @initial_state],
      registered: [ :stack ]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    []
  end
end

"""
$ iex -S mix
Erlang/OTP 18 [erts-7.0.3] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Interactive Elixir (1.0.5) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Stack.Server.pop
1
iex(2)> Stack.Server.pop
2
iex(3)> Stack.Server.pop
3
iex(4)> Stack.Server.pop
4
iex(5)> Stack.Server.push 10
:ok
iex(6)> Stack.Server.push 20
:ok
iex(7)> Stack.Server.push "Strings are harmless"
:ok
iex(8)>
19:09:15.588 [error] GenServer Stack.Server terminating
Last message: {:"$gen_cast", {:push, "Strings are harmless"}}
State: [data: [{'State', "My current state is '{[20, 10], #PID<0.86.0>}'"}]]
** (exit) an exception was raised:
    ** (RuntimeError) Invalid Operation: element must be a valid number
        (stack) lib/stack/server.ex:39: Stack.Server.handle_cast/2
        (stdlib) gen_server.erl:615: :gen_server.try_dispatch/4
        (stdlib) gen_server.erl:681: :gen_server.handle_msg/5
        (stdlib) proc_lib.erl:239: :proc_lib.init_p_do_apply/3

nil
iex(9)> Stack.Server.pop
20
iex(10)> Stack.Server.pop
10
"""
