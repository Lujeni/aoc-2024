defmodule RamRun do
  @directions [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]
  @grid_size 70

  def run(input) do
    bytes =
      String.split(input, "\n", trim: true)
      |> Enum.take(1024)
      |> Enum.map(fn line ->
        [x, y] = String.split(line, ",") |> Enum.map(&String.to_integer/1)
        {x, y}
      end)
      |> MapSet.new()

    bfs(bytes)
  end

  def bfs(
        bytes,
        start \\ {0, 0},
        dest \\ {@grid_size, @grid_size},
        queue \\ nil,
        visited \\ nil
      ) do
    queue = queue || :queue.from_list([{start, [start]}])
    visited = visited || MapSet.new([start])

    case :queue.out(queue) do
      {{:value, {current, path}}, new_queue} ->
        if current == dest do
          IO.puts(length(path))
        else
          {row, col} = current

          next_moves =
            @directions
            |> Enum.map(fn {dx, dy} -> {row + dx, col + dy} end)
            |> Enum.filter(fn {r, c} ->
              r >= 0 and r <= @grid_size and
                c >= 0 and c <= @grid_size and
                not MapSet.member?(bytes, {r, c}) and
                not MapSet.member?(visited, {r, c})
            end)

          {new_queue, new_visited} =
            Enum.reduce(next_moves, {new_queue, visited}, fn move, {q, v} ->
              {:queue.in({move, path ++ [move]}, q), MapSet.put(v, move)}
            end)

          bfs(bytes, start, dest, new_queue, new_visited)
        end
    end
  end
end

{:ok, input} = File.read("18.txt")
RamRun.run(input) |> IO.inspect()
