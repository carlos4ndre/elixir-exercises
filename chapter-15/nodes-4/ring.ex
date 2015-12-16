defmodule Ring do

  @name :ring

  def start do
    pid = spawn(__MODULE__, :client_manager, [[]])
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

  def client_manager(clients) do
    receive do
      { :join, pid } ->
        IO.puts "client #{inspect pid} has joined the ring"
        new_clients = clients ++ [pid]
        IO.puts "update clients links"
        update_clients_links(new_clients)
        client_manager(new_clients)
    end
  end
end

defmodule Client do

  @interval 10000  # 10 seconds

  def join do
    pid = spawn(__MODULE__, :receiver, [[]])
    Ring.join(pid)
  end

  def send_tick(next_client) do
    case next_client do
      nil -> IO.puts "End of the ring!"
      pid -> send pid, { :tick }
    end
  end

  def receiver(next_client) do
    receive do
      { :updateLink, next_client } ->
        receiver(next_client)
      { :tick } ->
        IO.puts "tick"
        send_tick(next_client)
        receiver(next_client)
    after @interval ->
      send_tick(next_client)
      receiver(next_client)
    end
  end
end
