defmodule Stack do
  use Application

  def start(_type, _args) do
    initial_state = Application.get_env(:stack, :initial_state)
    {:ok, _pid} = Stack.Supervisor.start_link(initial_state)
  end
end
