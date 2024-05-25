##Simple functions in Elixir
##
##Diego Ortega Fernández
##27/02/2024

defmodule Basics do

  def suma(a,b) do

  end

  def c_to_f(temp) do
    temp * 9 / 5 + 32
  end

  def f_to_c(temp) do
    (temp - 32) * 5 / 9
  end

end

IO.puts "Hello there"
IO.puts(Basicsc.suma(4,2)) ##IO es un módulo, necesito otro archivo para correrlo.
IO.puts(Basics.c_to_f(-40))
IO.puts(Basics.f_to_c(128))

IO.puts(Basics.f_to_c(Basicsc.c_to_f(36.4)))

#Pipe Operator

IO.gets("Enter a number: ")
|>  String.trim()
|>  String.to_float()
|>  Basics.c_to_f()
|>  Basics.f_to_c()
|>  Basics.suma(300)
|>  IO.puts()
