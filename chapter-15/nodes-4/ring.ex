defmodule Ring do

  @interval 10000  # 10 seconds
  @name :ring

  def start do
      pid = spawn(__MODULE__, :request_handler, [[]])
    :global.register_name(@name, pid)
  end

  def join(client_pid) do
    send :global.whereis_name(@name), { :join, client_pid }
  end

  def leave(client_pid) do
    send :global.whereis_name(@name), { :leave, client_pid }
  end

  def update_clients_links(clients) do
    case clients do
      [ client | other_clients ] ->
        next_client = List.first(other_clients)
        send client, { :updateLink, next_client }
        update_clients_links(other_clients)
      [] -> IO.puts "clients links updated"
    end
  end

  def send_tick(pid) do
    if pid do
      send pid, { :tick }
    end
  end

  def request_handler(clients) do
    receive do
      { :join, pid } ->
        IO.puts "client #{inspect pid} has joined the ring"
        new_clients = clients ++ [pid]
        IO.puts "update clients links"
        update_clients_links(new_clients)
        request_handler(new_clients)
      { :tick } ->
        first_client = List.first(clients)
        send_tick(first_client)
        request_handler(clients)
      after @interval ->
        # default action for this example
        send self, { :tick }
        request_handler(clients)
    end
  end
end

defmodule Client do

  def join do
    pid = spawn(__MODULE__, :receiver, [[]])
    Ring.join(pid)
  end

  def send_tick(next_client) do
    if next_client do
      send next_client, { :tick }
    end
  end

  def receiver(next_client) do
    receive do
      { :updateLink, next_client } ->
        receiver(next_client)
      { :tick } ->
        IO.puts "tick on node #{inspect self}"
        send_tick(next_client)
        receiver(next_client)
    end
  end
end
