defmodule Stack do
  use Application

  def start(_type, _args) do
    initial_stack = Application.get_env(:stack, :initial_stack)
    {:ok, _pid} = Stack.Supervisor.start_link(initial_stack)
  end
end
