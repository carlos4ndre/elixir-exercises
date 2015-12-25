defmodule StashTest do
  use ExUnit.Case

  @initial_value [1,2,3,4]

  setup do
    {:ok, stash} = Stack.Stash.start_link(@initial_value)
    {:ok, stash: stash}
  end

  test "get initial value", %{stash: stash} do
    assert Stack.Stash.get_value(stash) == @initial_value
  end

  test "save new value", %{stash: stash} do
    new_value = ["this", "is", "STASH"]
    Stack.Stash.save_value(stash, new_value)

    assert Stack.Stash.get_value(stash) == new_value
  end
end
