defmodule MathUtils do

  defmacro explain(clauses) do
    expression = Keyword.get(clauses, :do, nil)

    { _, translated_expression } = Macro.postwalk(expression, [], fn
      {operation, meta, [left, right]}, acc when is_number(left) and is_number(right) ->
        translation = "#{translate_operation(operation)} #{left} and #{right}"
        {"", acc ++ [translation]}
      {operation, meta, ["", right]}, acc when is_number(right) ->
        translation = "then #{translate_operation(operation)} #{right}"
        {"", acc ++ [translation]}
      {operation, meta, [left, right]}, acc when is_number(left) ->
        translation = "then #{translate_operation(operation)} #{left}"
        {"", acc ++ [translation]}
      other, acc ->
        {other, acc}
    end)

    translated_expression
    |> Enum.join(", ")
    |> IO.inspect
  end

  def translate_operation(operation) do
    case operation do
      :+ -> "add"
      :- -> "subtract"
      :* -> "multiply"
      :/ -> "divide"
      _  -> raise "Invalid operator"
    end
  end
end

defmodule Test do
  require MathUtils
  MathUtils.explain do: 2 + 3 * 4
  MathUtils.explain do: 2 + 3 * 4 + 3 + 4
end

"""
$ elixir -r my_math.ex
"multiply 3 and 4, then add 2"
"multiply 3 and 4, then add 2, then add 3, then add 4"
"""
