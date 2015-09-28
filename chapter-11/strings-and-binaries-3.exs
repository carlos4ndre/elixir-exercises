iex(1)> [ 'cat' | 'dog' ]
['cat', 100, 111, 103]
iex(2)> [[99, 97, 116] | [100, 111, 103]]
['cat', 100, 111, 103]

R: We get this result because basically we are appending a list of codepoints into the list,
leaving the 'cat' element untouched.
