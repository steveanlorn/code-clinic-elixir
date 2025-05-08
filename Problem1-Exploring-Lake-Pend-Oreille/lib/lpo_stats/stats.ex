defmodule LPOStats.Stats do
  @spec get_raw_stats(list(LPOStats.Weather.t()), atom()) :: {non_neg_integer(), float(), list(float())}
  def get_raw_stats(weathers, stat) do
    Enum.reduce(weathers, {0, 0.0, []}, fn weather, {count, sum, list} ->
      value = Map.get(weather, stat)
      {count + 1, sum + value, [value | list]}
    end)
  end

  def get_mean(_sum, 0), do: 0

  def get_mean(sum, count), do: sum / count

  def get_median(count, list) when rem(count, 2) == 1 do
    sorted = Enum.sort(list)
    mid = div(count, 2)
    Enum.at(sorted, mid)
  end

  def get_median(count, list) do
    sorted = Enum.sort(list)
    mid = div(count, 2)
    (Enum.at(sorted, mid - 1) + Enum.at(list, mid)) / 2
  end
end
