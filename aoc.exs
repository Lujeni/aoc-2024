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

    safe_reports =
      Enum.reduce(reports, 0, fn report, acc ->
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
    end)
    |> Enum.sum()
  end

  def mull_it_over() do
    # corrupted_memory = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
    result =
      File.read!("mull_it_over.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        check_corruption(line)
      end)
      |> Enum.sum()

    IO.puts(result)
  end

  def ceres_search() do
    word = ["X", "M", "A", "S"]

    directions = [
      {0, 1},
      {1, 0},
      {1, 1},
      {1, -1},
      {0, -1},
      {-1, 0},
      {-1, -1},
      {-1, 1}
    ]

    #    grid = "
    # MMMSXXMASM
    # MSAMXMSMSA
    # AMXSXMAAMM
    # MSAMASMSMX
    # XMASAMXAMM
    # XXAMMXXAMA
    # SMSMSASXSS
    # SAXAMASAAA
    # MAMMMXMMMM
    # MXMXAXMASX"
    grid =
      File.read!("ceres_search.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    # grid = [
    #   ["M", "M", "M", "S", "X", "X", "M", "A", "S", "M"],
    #   ["M", "S", "A", "M", "X", "M", "S", "M", "S", "A"],
    #   ["A", "M", "X", "S", "X", "M", "A", "A", "M", "M"],
    #   ["M", "S", "A", "M", "A", "S", "M", "S", "M", "X"],
    #   ["X", "M", "A", "S", "A", "M", "X", "A", "M", "M"],
    #   ["X", "X", "A", "M", "M", "X", "X", "A", "M", "A"],
    #   ["S", "M", "S", "M", "S", "A", "S", "X", "S", "S"],
    #   ["S", "A", "X", "A", "M", "A", "S", "A", "A", "A"],
    #   ["M", "A", "M", "M", "M", "X", "M", "M", "M", "M"],
    #   ["M", "X", "M", "X", "A", "X", "M", "A", "S", "X"]
    # ]

    for row <- 0..(length(grid) - 1),
        col <- 0..(length(Enum.at(grid, 0)) - 1),
        {move_to_row, move_to_col} <- directions,
        reduce: 0 do
      acc ->
        if Enum.with_index(word)
           |> Enum.all?(fn {char, i} ->
             next_row = row + i * move_to_row
             next_col = col + i * move_to_col

             IO.puts(
               "check #{char} on position #{row}-#{col} for direction #{next_row}-#{next_col}"
             )

             # we move !
             next_row >= 0 and next_col >= 0 and
               next_row < length(grid) and
               next_col < length(Enum.at(grid, 0)) and
               Enum.at(Enum.at(grid, next_row), next_col) == char

             # IO.puts("#{row}-#{col}")
             # IO.puts("#{next_row}-#{next_col}")
             # next_char = Enum.at(Enum.at(grid, next_row), next_col)
             # IO.puts("#{next_char}")
           end) do
          acc + 1
        else
          acc
        end
    end
  end

  def print_queue() do
    input = File.read!("print_queue_1.txt")
    [rules_section, updates_section] = String.split(input, "\n\n")

    rules =
      rules_section
      |> String.split("\n", trim: true)
      |> Enum.map(fn rule ->
        [a, b] = String.split(rule, "|") |> Enum.map(&String.to_integer/1)
        {a, b}
      end)

    updates =
      updates_section
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    updates
    |> Enum.filter(fn update -> is_valid_order?(update, rules) end)
    |> Enum.map(fn update -> Enum.at(update, div(length(update), 2)) end)
    |> Enum.sum()
  end

  defp is_valid_order?(update, rules) do
    Enum.all?(rules, fn {a, b} ->
      if a in update and b in update do
        Enum.find_index(update, &(&1 == a)) < Enum.find_index(update, &(&1 == b))
      else
        true
      end
    end)
  end
end

# total_distance = AdventOfCode.historian_hysteria()
# IO.puts("La distance totale est : #{total_distance}")
# AdventOfCode.red_nose_reports()
# AdventOfCode.mull_it_over()
# AdventOfCode.ceres_search() |> IO.puts
AdventOfCode.print_queue() |> IO.puts()
