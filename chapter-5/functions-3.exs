fizzbuzz = fn
  0, 0, _ -> "FizzBuzz"
  0, _, _ -> "Fizz"
  _, 0, _ -> "Buzz"
  _, _, c -> c
end
calc_fizzbuzz = fn n -> fizzbuzz.(rem(n, 3), rem(n, 5), n) end
IO.puts calc_fizzbuzz.(10) # Buzz
IO.puts calc_fizzbuzz.(11) # 11
IO.puts calc_fizzbuzz.(12) # Fizz
IO.puts calc_fizzbuzz.(13) # 13
IO.puts calc_fizzbuzz.(14) # 14
IO.puts calc_fizzbuzz.(15) # FizzBuzz
IO.puts calc_fizzbuzz.(16) # 16
