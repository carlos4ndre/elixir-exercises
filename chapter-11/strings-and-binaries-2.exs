defmodule MyStringUtil do
  def anagram?(str1, str2), do: _anagram?(
    str1
      |> String.downcase
      |> String.to_char_list,
    String.downcase(str2))

  defp _anagram?([], _), do: true
  defp _anagram?([ head | tail ], str2) do
    if String.contains?(str2, to_string([head])) do
      _anagram?(tail, str2)
    else
      false
    end
  end
end

IO.inspect MyStringUtil.anagram?("Evil","Live")
IO.inspect MyStringUtil.anagram?("Cats","Dogs")
