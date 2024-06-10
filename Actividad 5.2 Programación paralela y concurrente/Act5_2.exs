#Actividad 5.2 Programación paralela y concurrente
#
#Diego Ortega Fernández - A01028535
#09/06/2024


defmodule Hw.Primes do

  defp is_prime(n) when n < 2, do: false
  defp is_prime(2), do: true
  defp is_prime(n) do
    max_divisor = :math.sqrt(n) |> trunc()
    2..max_divisor |> Enum.all?(fn x -> rem(n, x) != 0 end)
  end


  defp sum_primes_in_range(lower, upper) do
    Enum.reduce(lower..upper, 0, fn x, acc ->
      if is_prime(x), do: acc + x, else: acc
    end)
  end
  
  def sum_primes(limit) do
    sum_primes_in_range(2, limit - 1)
  end

  defp ranges(lower, upper, num_threads) do
    step = div(upper - lower + 1, num_threads)
    Enum.map(0..(num_threads - 1), fn i ->
      start = lower + i * step
      finish = if i == num_threads - 1, do: upper, else: start + step - 1
      {start, finish}
    end)
  end

  def sum_primes_parallel(limit, num_threads) do
    ranges(2, limit - 1, num_threads)
    |> Enum.map(fn {lower, upper} ->
      Task.async(fn -> sum_primes_in_range(lower, upper) end)
    end)
    |> Enum.map(&Task.await/1)
    |> Enum.sum()
  end
end

defmodule Hw.PrimesBenchmark do
  def run_benchmark do
    limit = 5_000_000
    num_threads = 8

#----- tiempo secuencial
    {time_seq, result_seq} = :timer.tc(fn -> Hw.Primes.sum_primes(limit) end)
    IO.puts("Resultado secuencial: #{result_seq}")
    IO.puts("Tiempo de ejecución (secuencial): #{time_seq / 1_000_000} segundos")

#----- tiempo paralelo
    {time_par, result_par} = :timer.tc(fn -> Hw.Primes.sum_primes_parallel(limit, num_threads) end)
    IO.puts("Resultado paralelo: #{result_par}")
    IO.puts("Tiempo de ejecución (paralelo): #{time_par / 1_000_000} segundos")

#-- speedup
    speedup = time_seq / time_par
    IO.puts("Speedup con #{num_threads} procesadores: #{speedup}")
  end
end

Hw.PrimesBenchmark.run_benchmark()
