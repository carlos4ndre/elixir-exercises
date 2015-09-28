defmodule MyWordUtils do
  def capitalize_sentences(text), do: _capitalize_sentences(String.split(text, ". "), "")

  defp _capitalize_sentences([sentence | []], result) do # last element of split should not have ". "should not have ". "
      _capitalize_sentences([], "#{result}#{sentence}")
  end
  defp _capitalize_sentences([sentence | tail], result) do
      _capitalize_sentences(tail, "#{result}#{String.capitalize(sentence)}. ")
  end
  defp _capitalize_sentences([], result), do: IO.puts result
end

IO.puts MyWordUtils.capitalize_sentences("oh. a DOG. woof. ") #"Oh. A dog. Woof. "
IO.puts MyWordUtils.capitalize_sentences("oh. a CAT. meow") #"Oh. A cat meow"
