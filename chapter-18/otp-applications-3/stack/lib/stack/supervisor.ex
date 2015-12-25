defmodule Stack.Supervisor do
  use Supervisor

  def start_link(initial_stack) do
    result = {:ok, sup} = Supervisor.start_link(__MODULE__, [initial_stack])
    start_workers(sup, initial_stack)
    result
  end

  def start_workers(sup, initial_stack) do
    # Start stash worker
    {:ok, stash_pid} =
      Supervisor.start_child(sup, worker(Stack.Stash, [initial_stack]))
    # Start stack supervisor
    Supervisor.start_child(sup, supervisor(Stack.SubSupervisor, [stash_pid]))
  end

  def init(_) do
    supervise [], strategy: :one_for_one
  end
end
