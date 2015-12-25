defmodule Stack.Server do
  use GenServer
  require Logger

  defmodule State, do: defstruct current_stack: [], stash_pid: nil

  @vsn "1"

  #####
  # External API

  def start_link(stash_pid) do
    {:ok,_pid} = GenServer.start_link(__MODULE__, stash_pid, name: __MODULE__)
  end

  def pop do
    GenServer.call(__MODULE__, :pop)
  end

  def push(element) do
    GenServer.cast(__MODULE__, {:push, element})
  end

  #####
  # GenServer Implementation

  def init(stash_pid) do
    current_stack = Stack.Stash.get_value stash_pid
    { :ok, %State{current_stack: current_stack, stash_pid: stash_pid} }
  end

  def handle_call(:pop, _from, %State{current_stack: current_stack} = state) when length(current_stack) == 0 do
    raise "Invalid Operation: pop on empty stack"
  end

  def handle_call(:pop, _from, state) do
    first_element = List.first(state.current_stack)
    new_list = List.delete_at(state.current_stack, 0)

    {
      :reply,
      first_element,
      %{ state | current_stack: new_list }
    }
  end

  def handle_cast({:push, new_element}, state) when not is_number(new_element) do
    raise "Invalid Operation: element must be a valid number"
  end

  def handle_cast({:push, new_element}, state) do
    new_list = List.insert_at(state.current_stack, 0, new_element)

    {
      :noreply,
      %{ state | current_stack: new_list}
    }
  end

  def terminate(_reason, state) do
    Stack.Stash.save_value state.stash_pid, state.current_stack
  end

  def format_status(_reason, [ _pdict, state ]) do
    [data: [{'State', "My current state is '#{inspect state}'"}]]
  end

  def code_change("0", old_state = { current_stack, stash_pid }, _extra) do
    new_state = %State{
      current_stack: current_stack,
      stash_pid: stash_pid}
    Logger.info "Changing code form 0 to 1"
    Logger.info inspect(old_state)
    Logger.info inspect(new_state)
    { :ok, new_state }
  end
end
