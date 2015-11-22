defmodule SpawnTest do
  def sendToken  do
    receive do
      {sender, msg} ->
        send sender, { :ok, "token: #{msg}"}
        sendToken
    end
  end
end

### Spawn processes #1 and #2
pid1 = spawn(SpawnTest, :sendToken, [])
pid2 = spawn(SpawnTest, :sendToken, [])

### send unique token to process #1
send pid1, {self, "Mr. Bean"}
receive do
  {:ok, message} ->
    IO.puts message
end

### send unique token to process #2
send pid2, {self, "Mr. Magoo"}
receive do
  {:ok, message} ->
    IO.puts message
end

"""
$ elixir -r spawn.exs
token: Mr. Bean
token: Mr. Magoo
"""

