Code.require_file "caesar.ex", __DIR__

### Thanks to Minho University! For providing a list of portuguese words.
### http://natura.di.uminho.pt/download/sources/Dictionaries/wordlists

defmodule Words do
  def find_rot13_words_in_file(filepath) do
    mapper = fn x -> Caesar.rot13(x) end

    filepath
    |> load_words_from_file
    |> filter_matching_words(mapper)
  end

  def load_words_from_file(filepath) do
    if File.exists?(filepath) do
      stream = File.stream!(filepath)
      data = Enum.reduce stream, [], fn(word, words) ->
        word = String.strip(word)
        [ word | words ]
      end
      data
    else
      raise "Error: #{filepath} does not exists"
    end
  end

  def filter_matching_words(words, func) do
    group_words_by_size(words)
    |> Enum.map(fn {word_size, words_group} ->
      mapped_words_group = Enum.map(words_group, func)
      intersect_lists(words_group, mapped_words_group)
    end)
    |> List.flatten
  end

  def group_words_by_size(words) do
    Enum.reduce(words, HashDict.new, fn(word, groups) ->
      word_size = count_word_size(word)
      old_value = HashDict.get(groups, word_size, [])
      new_value = Enum.into(old_value, [word])
      HashDict.put(groups, word_size, new_value)
    end)
  end

  def intersect_lists(list1, list2) do
      setA = Enum.into(list1, HashSet.new)
      setB = Enum.into(list2, HashSet.new)
      Set.intersection(setA, setB) |> HashSet.to_list
  end

  def count_word_size(word) do
    String.length(word)
  end
end

Words.find_rot13_words_in_file('data/wordlist-basic.txt')
|> Enum.each &(IO.puts &1)

Words.find_rot13_words_in_file('data/wordlist-prea.txt')
|> Enum.each &(IO.puts &1)

"""
$ elixir -r rot13_words.ex
# result from basic wordlist
asdfasdfas
nfqsnfqsnf

# result from portuguese wordlist
cr
ns
oh
ah
bu
PR
na
ru
an
nu
pe
af
eh
aba
beb
irm
puf
vez
ore
OPV
nen
non
ver
ber
oro
chs
ire
ara
gera
tren
trar
gene
punir
chave
s
z
n
a
m
b
r
f
e
p
c
o
"""
