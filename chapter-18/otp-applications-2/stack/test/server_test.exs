defmodule ServerTest do
  use ExUnit.Case

  test "push elements to stack" do
    test_values = 1..10

    # populate stack
    test_values
    |> Enum.each &(Stack.Server.push &1)

    # check elements order
    test_values
    |> Enum.reverse
    |> Enum.each &(assert Stack.Server.pop == &1)
  end

  # NOTE: Cannot test exceptions with the current design
  # as the pid of the Stack Server is not known to us
  # and spawning a new process would require killing the existing
  # one.
  # "There can be only one" - __MODULE__ the highlander
end
