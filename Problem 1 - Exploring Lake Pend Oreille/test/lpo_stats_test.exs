defmodule LPOStatsTest do
  use ExUnit.Case

  doctest LPOStats

  setup_all do
    file = Path.join(__DIR__, "testdata/test_data_for_get_stats.txt")
    assert {:ok, weathers} = LPOStats.load_weathers(file)
    %{weathers: weathers}
  end

  @expected %{
    air_temp: %{
      mean: 19.636,
      median: 19.68
    },
    barometric_press: %{
      mean: 30.612,
      median: 30.61
    },
    dew_point: %{
      mean: 15.002,
      median: 15.18
    },
    relative_humidity: %{
      mean: 81.889,
      median: 82.00
    },
    wind_dir: %{
      mean: 159.973,
      median: 159.78
    },
    wind_gust: %{
      mean: 12.556,
      median: 13.00
    },
    wind_speed: %{
      mean: 9.378,
      median: 9.40
    },
  }

  @stats LPOStats.Type.stats()

  Enum.each(@stats, fn stat ->
    test "#{stat} stats should return correct result", %{weathers: weathers} do
      stats = apply(LPOStats, :"get_#{unquote(stat)}", [weathers])

      expected = Map.fetch!(@expected, unquote(stat))
      mean = Float.round(stats.mean, 3)

      assert mean == expected.mean, "unexpected mean value, got #{mean}"
      assert stats.median == expected.median, "unexpected median value, got #{stats.median}"
    end
  end)
end
