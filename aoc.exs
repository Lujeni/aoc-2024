defmodule AdventOfCode do
  def historian_hysteria() do
    {:ok, content} = File.read("1.txt")
    lines = String.split(content, "\n", trim: true)

    # Reduce the input into two lists: left_list and right_list
    {left_list, right_list} = Enum.reduce(lines, {[], []}, fn line, {left_list, right_list} ->
      # Split each line into two parts: left and right
      [left, right] = String.split(line, ~r/\s+/, trim: true)
      {
        left_list ++ [String.to_integer(left)],
        right_list ++ [String.to_integer(right)]
      }
    end)

    sorted_left = Enum.sort(left_list)
    sorted_right = Enum.sort(right_list)

    Enum.zip(sorted_left, sorted_right)
    |> Enum.reduce(0, fn {a, b}, acc ->
      acc + abs(a - b)
    end)
  end
end

total_distance = AdventOfCode.historian_hysteria()
IO.puts("La distance totale est : #{total_distance}")
