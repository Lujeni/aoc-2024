defmodule BridgeRepair do
  @operators [:+, :*]

  defp reduce_combo(length) do
    Enum.reduce(1..length, [[]], fn _, acc ->
      for combo <- acc, op <- @operators do
        [op | combo]
      end
    end)
  end

  defp apply_combo([number], []), do: number
  defp apply_combo([num1, num2 | rest], [op | ops]) do
    result =
      case op do
        :+ -> num1 + num2
        :* -> num1 * num2
      end

    apply_combo([result | rest], ops)
  end

  def run(input) do
    parsed_results =
      input
      |> Enum.map(fn string ->
        string
        |> String.split(": ", parts: 2)
        |> then(fn [first, rest] ->
          {
            String.to_integer(first),
            rest
            |> String.split()
            |> Enum.map(&String.to_integer/1)
          }
        end)
      end)

    parsed_results
    |> Enum.reduce(0, fn {sum, numbers}, acc ->
      combos = reduce_combo(length(numbers) - 1)
      results = Enum.map(combos, fn combo -> apply_combo(numbers, combo) end)
      if sum in results do
        acc + sum
      else
        acc
      end
    end)
    |> IO.puts
  end
end

input =
  File.read!("bridge_repair2.txt")
  |> String.split("\n", trim: true)

BridgeRepair.run(input)
