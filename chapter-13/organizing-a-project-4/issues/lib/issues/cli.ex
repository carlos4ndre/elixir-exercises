defmodule Issues.CLI do

  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating a
  table of the last _n_ issues in a github project
  """

  def run(argv) do
    argv
      |> parse_args
      |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it is a github user name, project name, and (optionally)
  the number of entries to format.

  Return a tuple of `{ user, project, count }`, or `:help` if help was given.
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [ help: :boolean],
                                     aliases:  [ h:    :help   ])
    case parse do
      { [ help: true ], _,           _ } -> :help
      { _, [ user, project, count ], _ } -> { user, project, String.to_integer(count) }
      { _, [ user, project ],        _ } -> { user, project, @default_count }
      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage:  issues <user> <project> [ count | #{@default_count} ]
    """
    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response
    |> convert_to_list_of_hashdicts
    |> sort_into_ascending_order
    |> Enum.take(count)
    |> print_table_for_columns(["number","created_at","title"])
  end

  def decode_response({:ok, body}), do: body
  def decode_response({:error, error}) do
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from Github: #{message}"
    System.halt(2)
  end

  def convert_to_list_of_hashdicts(list) do
    list
    |> Enum.map(&Enum.into(&1, HashDict.new))
  end

  def sort_into_ascending_order(list_of_issues) do
    Enum.sort list_of_issues,
      fn i1, i2 -> i1["created_at"] <= i2["created_at"] end
  end

  def print_table_for_columns(issues, columns) do
    rows = process_table_rows(issues, columns)
    columns_max_size = get_columns_max_size(rows, columns)
    print_table_headers(columns, columns_max_size)
    print_table_separator(columns, columns_max_size)
    print_table_body(rows, columns_max_size)
    issues
  end

  def process_table_rows(issues, columns) do
    issues
    |> Enum.map &(process_table_row(&1, columns))
  end

  def process_table_row(issue, columns) do
    columns
    |> Enum.map &(issue[&1])
  end

  def print_table_headers(columns, columns_max_size) do
    header_columns = get_header_columns(columns)
    Enum.zip(header_columns, columns_max_size)
    |> Enum.map_join(" | ",
      &(String.ljust(
        to_string(get_tuple_key(&1)),
        get_tuple_value(&1))))
    |> IO.puts
  end

  def print_table_separator(columns, columns_max_size) do
    Enum.zip(columns, columns_max_size)
    |> Enum.map_join("-+-",
      &(String.ljust("", get_tuple_value(&1), ?-)))
    |> IO.puts
  end

  def print_table_body(rows, columns_max_size) do
    rows
    |> Enum.each &(print_table_row(&1,columns_max_size))
  end

  def print_table_row(values, columns_max_size) do
    Enum.zip(values, columns_max_size)
    |> Enum.map_join(" | ",
      &(String.ljust(to_string(get_tuple_key(&1)),
        get_tuple_value(&1))))
    |> IO.puts
  end

  def get_columns_max_size(rows, columns) do
    total_rows = Enum.into(rows, [columns])
    get_iter_counters(columns)
    |> Enum.map(&(get_column_max_size(total_rows, &1))) # rows
  end

  def get_column_max_size(rows, column_number) do
    rows
    |> get_column_values(column_number)
    |> get_longest_value
    |> get_cell_size
  end

  def get_column_values(rows, column_number) do
    rows
    |> Enum.map &(Enum.at(&1, column_number))
  end

  def get_longest_value(list) do
    list
    |> Enum.max_by &(String.length(to_string(&1)))
  end

  def get_cell_size(value) do
    value
    |> to_string
    |> String.length
  end

  def get_iter_counters(list) do
    total_num_elements = length list
    Stream.iterate(0, &(&1+1))
    |> Enum.take(total_num_elements)
  end

  def get_header_columns(list) do
    case list do
      ["number" | tail ] ->
        [ "#" | get_header_columns(tail) ]
      [ head | tail ]->
        [ head | get_header_columns(tail) ]
      [] -> []
    end
  end

  def get_tuple_key(tuple) do
    tuple
    |> Tuple.to_list
    |> Enum.at(0)
  end

  def get_tuple_value(tuple) do
    tuple
    |> Tuple.to_list
    |> Enum.at(1)
  end
end
