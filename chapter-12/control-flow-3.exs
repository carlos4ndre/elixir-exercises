defmodule MyUtils do
  def ok!(result) do
    case result do
      {:ok, file} -> print(file)
      {:error, reason} -> raise "Failed to open hell gate: #{reason}"
    end
  end

  def print(file) do
     file
		 |> IO.stream(:line)
     |> Enum.map(fn w -> IO.write "#{w}" end)
  end

end

MyUtils.ok! File.open("control-flow-1.exs") # prints out source code
MyUtils.ok! File.open("control-flow-666.exs") # throws exception
