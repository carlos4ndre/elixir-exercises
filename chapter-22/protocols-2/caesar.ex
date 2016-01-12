defmodule Cypher do
  def caesar([], _n), do: []

  def caesar([ head | tail ], n)
    when head+n <= ?z,
    do: [ head+n | caesar(tail, n) ]

  def caesar([ head | tail ], n),
    do: [ head+n-26 | caesar(tail, n) ]
end

defprotocol Caesar do
  def encrypt(string, shift)
  def rot13(string)
end

defimpl Caesar, for: List do
  def encrypt(string, shift) do
    Cypher.caesar(string, shift)
  end

  def rot13(string) do
    Cypher.caesar(string, 13)
  end
end

defimpl Caesar, for: BitString do
  def encrypt(string, offset) do
    string |> to_char_list |> Cypher.caesar(offset) |> to_string
  end

  def rot13(string) do
    string |> to_char_list |> Cypher.caesar(13) |> to_string
  end
end

