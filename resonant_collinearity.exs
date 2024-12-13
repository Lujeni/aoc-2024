Mix.install([
  :combination
])

defmodule ResonantCollinearity do
  def run(input) do
    map_height = Enum.count(input)
    map_width = String.length(Enum.at(input, 0))

    map =
      input
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, y} ->
        row
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.filter(fn {char, _} -> char != "." end)
        |> Enum.map(fn {char, x} -> {char, {x, y}} end)
      end)

    combo =
      map
      |> Enum.group_by(fn {freq, _locations} -> freq end)
      |> Enum.flat_map(fn {freq, locations} ->
        locations
        |> Enum.map(fn {freq, coord} -> coord end)
        |> Combination.combine(2)
        |> Enum.map(fn [coord1, coord2] -> {freq, coord1, coord2} end)
      end)

    antinodes =
      combo
      |> Enum.flat_map(fn {freq, {x1, y1}, {x2, y2}} ->
        dx = x2 - x1
        dy = y2 - y1
        antinode1 = {x1 - dx, y1 - dy}
        antinode2 = {x2 + dx, y2 + dy}
        [antinode1, antinode2]
      end)

    antinodes
    |> Enum.filter(fn {x, y} ->
      x >= 0 and x < map_width and y >= 0 and y < map_height
    end)
    |> Enum.uniq()
    |> Enum.count()
    |> IO.puts()
  end
end

# File.read!("8bis.txt")
grid =
  File.read!("8.txt")
  |> String.split("\n", trim: true)

ResonantCollinearity.run(grid)
