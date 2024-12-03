defmodule AdventOfCode do
  def historian_hysteria() do
    {:ok, content} = File.read("historian_hysteria.txt")
    lines = String.split(content, "\n", trim: true)

    # Reduce the input into two lists: left_list and right_list
    {left_list, right_list} =
      Enum.reduce(lines, {[], []}, fn line, {left_list, right_list} ->
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

  # reduce_while(enumerable, acc, fun)
  # Reduces enumerable until fun returns {:halt, term}.
  def is_asc(report) do
    Enum.reduce_while(report, true, fn
      x, true -> {:cont, x}
      x, prev when prev < x and x - prev <= 3 -> {:cont, x}
      _x, _ -> {:halt, false}
    end) !== false
  end

  def is_desc(report) do
    Enum.reduce_while(report, true, fn
      x, true -> {:cont, x}
      x, prev when prev > x and prev - x <= 3 -> {:cont, x}
      _x, _ -> {:halt, false}
    end) !== false
  end

  def red_nose_reports() do
    reports =
      File.read!("red_nose_reports.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split(" ")
        |> Enum.map(&String.to_integer/1)
      end)

    safe_reports = Enum.reduce(reports, 0, fn report, acc ->
      if is_asc(report) or is_desc(report) do
        acc + 1
      else
        acc
      end
    end)
    IO.puts("Number of safe reports: #{safe_reports}")
  end

  def check_corruption(line) do
    regex = ~r/mul\((\d{1,3}),(\d{1,3})\)/
    Regex.scan(regex, line)
    |> Enum.map(fn [_, a, b] ->
      String.to_integer(a) * String.to_integer(b)
    end) |> Enum.sum()
  end

  def mull_it_over() do
    # corrupted_memory = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
    result = File.read!("mull_it_over.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
          check_corruption(line)
      end) |> Enum.sum()
    IO.puts(result)
  end
end

# total_distance = AdventOfCode.historian_hysteria()
# IO.puts("La distance totale est : #{total_distance}")
# AdventOfCode.red_nose_reports()
AdventOfCode.mull_it_over()
