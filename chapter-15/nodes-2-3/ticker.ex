defmodule Ticker do

  @interval 10000  # 10 seconds
  @name     :ticker

  def start do
    pid = spawn(__MODULE__, :generator, [[]])
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    send :global.whereis_name(@name), { :register, client_pid }
  end

  def generator(clients) do
    receive do
      { :register, pid } ->
        IO.puts "registering #{inspect pid}"
        generator(clients ++ [pid])
    after
      @interval ->
        IO.puts "tick"
        Enum.each clients, fn client ->
          IO.puts "send tick to client #{inspect client}"
          send client, { :tick }
        end
        generator(clients)
    end
  end
end

defmodule Client do

  def start do
    pid = spawn(__MODULE__, :receiver, [])
    Ticker.register(pid)
  end

  def receiver do
    receive do
      { :tick } ->
        IO.puts "tock in client"
        receiver
    end
  end
end

"""
R: The tick will only take 2s if there is no registration.
Otherwise, It will reset the receive timeout for another 2s.
This was tested using 5s interval between 5 consecutive
registrations, delaying the tick for about 25s.

### Node one
# 1) Start Node one
$ iex --sname one
Erlang/OTP 18 [erts-7.0.3] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Interactive Elixir (1.0.5) - press Ctrl+C to exit (type h() ENTER for help)

# 2) Compile ticker.ex
iex(one@D4rkP0rtal)1> c("ticker.ex")
ticker.ex:1: warning: redefining module Ticker
ticker.ex:32: warning: redefining module Client
[Client, Ticker]

# 5) Connect to node two
iex(one@D4rkP0rtal)2> Node.connect :"two@D4rkP0rtal"
true
iex(one@D4rkP0rtal)3> Node.list
[:two@D4rkP0rtal]

# 6) Start ticker process with 10s timeout
iex(one@D4rkP0rtal)6> Ticker.start
:yes
registering #PID<11961.80.0>
registering #PID<11961.82.0>
registering #PID<11961.84.0>
registering #PID<11961.86.0>
registering #PID<11961.88.0>
tick
send tick to client #PID<11961.80.0>
send tick to client #PID<11961.82.0>
send tick to client #PID<11961.84.0>
send tick to client #PID<11961.86.0>
send tick to client #PID<11961.88.0>

### Node two
# 3) Start node two
$iex --sname two
Erlang/OTP 18 [erts-7.0.3] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Interactive Elixir (1.0.5) - press Ctrl+C to exit (type h() ENTER for help)

# 4) Compile ticker.ex
$ iex(two@D4rkP0rtal)1> c("ticker.ex")
ticker.ex:1: warning: redefining module Ticker
ticker.ex:32: warning: redefining module Client
[Client, Ticker]

# 7) Start multiple clients every 5s
iex(two@D4rkP0rtal)2> Client.start # will reset receive timeout (10s)
{:register, #PID<0.80.0>}
iex(two@D4rkP0rtal)3> Client.start # will reset receive timeout (10s)
{:register, #PID<0.82.0>}
iex(two@D4rkP0rtal)4> Client.start # will reset receive timeout (10s)
{:register, #PID<0.84.0>}
iex(two@D4rkP0rtal)5> Client.start # will reset receive timeout (10s)
{:register, #PID<0.86.0>}
iex(two@D4rkP0rtal)6> Client.start # will reset receive timeout (10s)
{:register, #PID<0.88.0>}
tock in client
tock in client
tock in client
tock in client
tock in client
"""
