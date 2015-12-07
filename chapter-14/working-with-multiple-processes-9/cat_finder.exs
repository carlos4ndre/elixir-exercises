defmodule CatServer do

  def count_number_of_cats(scheduler) do
    send scheduler, { :ready, self }
    receive do
      { :process, params, client } ->
        send client, { :answer, params, count_cats_in_dir(params[:dir]), self }
        count_number_of_cats(scheduler)
      { :shutdown } ->
        exit(:normal)
    end
  end

  def count_cats_in_dir(dir) do
    File.ls!(dir)
    |> Enum.map(fn(filename) ->
      filepath = "#{dir}/#{filename}"
      spawn(CatServer, :count_cats_in_file, [filepath, self])
    end)
    |> Enum.map(fn(pid) ->
      receive do { ^pid, result } -> result end
    end)
    |> Enum.sum
  end

  def count_cats_in_file(filepath, client) do
    result = count_matches_in_file(filepath, "cat")
    send client, { self, result }
  end

  def count_matches_in_file(filepath, pattern) do
    File.stream!(filepath)
    |> Enum.map(&(count_matches(&1, pattern)))
    |> Enum.sum
  end

  def count_matches(str, pattern) do
    str
    |> String.split
    |> Enum.filter(&(String.contains?(&1, pattern)))
    |> Enum.count
  end
end

defmodule Scheduler do

  def run(num_processes, module, func, to_process) do
    (1..num_processes)
    |> Enum.map(fn(_) -> spawn(module, func, [self]) end)
    |> schedule_processes(to_process, [])
  end

  defp schedule_processes(processes, queue, results) do
    receive do
      {:ready, pid} when length(queue) > 0 ->
        [ next | tail ] = queue
        send pid, {:process, next, self}
        schedule_processes(processes, tail, results)

      {:ready, pid} ->
        send pid, {:shutdown}
        if length(processes) > 1 do
          schedule_processes(List.delete(processes, pid), queue, results)
        else
          Enum.sort(results, fn {n1,_}, {n2,_} -> n1 <= n2 end)
        end

      {:answer, params, result, _pid} ->
        schedule_processes(processes, queue, [{params, result} | results])
    end
  end
end

to_process = 1..5000 |> Enum.map(fn(_) -> %{ :dir => 'tests' } end)

Enum.each 1..10, fn num_processes ->
  {time, result} = :timer.tc(Scheduler, :run,
                            [num_processes, CatServer, :count_number_of_cats, to_process])
  if num_processes == 1 do
    IO.puts inspect result
    IO.puts "\n #   time (s)"
  end
  :io.format "~2B    ~.2f~n", [num_processes, time/1000000.0]
end

"""
### to_process = 1..5
$ elixir cat_finder.exs
#   time (s)
 1    0.12
 2    0.11
 3    0.11
 4    0.11
 5    0.11
 6    0.11
 7    0.11
 8    0.10
 9    0.09
10    0.09


### to_process = 1..50
$ elixir cat_finder.exs
 #   time (s)
 1    1.10
 2    0.93
 3    1.00
 4    1.04
 5    0.98
 6    1.03
 7    1.03
 8    1.02
 9    0.98
10    0.96


### to_process = 1..500
$ elixir cat_finder.exs
#   time (s)
 1    11.05
 2    10.07
 3    10.24
 4    10.18
 5    10.01
 6    10.29
 7    10.00
 8    10.03
 9    9.96
10    10.06


### to_process = 1..5000
$ elixir cat_finder.exs
#   time (s)
 1    111.67
 2    103.04
 3    103.47
 4    99.37
 5    100.88
 6    100.55
 7    101.05
 8    101.33
 9    101.88
10    102.45
"""
