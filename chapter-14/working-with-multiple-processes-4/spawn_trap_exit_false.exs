defmodule SpawnTest do
  import :timer, only: [ sleep: 1 ]

  def sad_function do
    receive do
      {sender, msg} ->
        send sender, msg
        exit(:boom)
    end
  end

  def run do
    Process.flag(:trap_exit, false)
    pid = spawn_link(SpawnTest, :sad_function, [])

    # send messages
    send pid, {self, "DragonForce"}
    send pid, {self, "Rhapsody"}
    send pid, {self, "Stratovarius"}

    # wait for 10 seconds
    sleep 10000

    # receive message #1
    receive do
      msg ->
        IO.puts "MESSAGE RECEIVED: #{inspect msg}"
      after 1000 ->
        IO.puts "Nothing happened as far as I am concerned"
    end

    # receive message #2
    receive do
      msg ->
        IO.puts "MESSAGE RECEIVED: #{inspect msg}"
      after 1000 ->
        IO.puts "Nothing happened as far as I am concerned"
    end

    # receive message #3
    receive do
      msg ->
        IO.puts "MESSAGE RECEIVED: #{inspect msg}"
      after 1000 ->
        IO.puts "Nothing happened as far as I am concerned"
    end
  end
end

SpawnTest.run

"""
$ elixir -r spawn_trap_exit_false.exs
* (EXIT from #PID<0.49.0>) :boom
"""

