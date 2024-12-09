defmodule GuardGallivant do
  def run(grid) do
    simulate = fn simulate, map, pos, dir, visited ->
      move = fn
        {x, y}, :up -> {x, y - 1}
        {x, y}, :down -> {x, y + 1}
        {x, y}, :left -> {x - 1, y}
        {x, y}, :right -> {x + 1, y}
      end

      turn_right = fn
        :up -> :right
        :right -> :down
        :down -> :left
        :left -> :up
      end

      next_pos = move.(pos, dir)

      if not Map.has_key?(map, next_pos) do
        MapSet.size(visited)
      else
        case Map.get(map, next_pos) do
          "#" ->
            new_dir = turn_right.(dir)
            simulate.(simulate, map, pos, new_dir, visited)

          _ ->
            simulate.(simulate, map, next_pos, dir, MapSet.put(visited, next_pos))
        end
      end
    end

    {map, start_pos, start_dir} =
      Enum.with_index(grid)
      |> Enum.reduce({%{}, nil, nil}, fn {line, y}, {acc_map, acc_pos, acc_dir} ->
        Enum.with_index(String.graphemes(line))
        |> Enum.reduce({acc_map, acc_pos, acc_dir}, fn
          {"^", x}, {map_acc, _, _} ->
            {Map.put(map_acc, {x, y}, "."), {x, y}, :up}

          {">", x}, {map_acc, _, _} ->
            {Map.put(map_acc, {x, y}, "."), {x, y}, :right}

          {"v", x}, {map_acc, _, _} ->
            {Map.put(map_acc, {x, y}, "."), {x, y}, :down}

          {"<", x}, {map_acc, _, _} ->
            {Map.put(map_acc, {x, y}, "."), {x, y}, :left}

          {char, x}, {map_acc, pos_acc, dir_acc} ->
            {Map.put(map_acc, {x, y}, char), pos_acc, dir_acc}
        end)
      end)

    visited = MapSet.new([start_pos])
    simulate.(simulate, map, start_pos, start_dir, visited)
  end
end

grid =
  File.read!("guard_gallivant.txt")
  |> String.split("\n", trim: true)

IO.puts(GuardGallivant.run(grid))
