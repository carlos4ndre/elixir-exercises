prefix = fn prefix ->
  fn name -> "#{prefix} #{name}" end
end
IO.puts prefix.("Mrs").("Smith")
IO.puts prefix.("Elixir").("Rocks")
