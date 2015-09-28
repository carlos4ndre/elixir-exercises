defmodule MyStringUtil do
  def printable?([]), do: true
  def printable?([ char | tail ]) do
    if String.printable?(to_string [char]) do
      printable?(tail)
    else
      false
    end
  end
end

IO.inspect MyStringUtil.printable?('Carlos André');
IO.inspect MyStringUtil.printable?([ 0 ]); # NULL
IO.inspect MyStringUtil.printable?([ 65, 66, 22, 70 ]); # SYN
