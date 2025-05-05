defmodule LPOStats do
  @moduledoc """
  LPOStats module provides functions to
  get the weather data statistic of Lake Pend Oreille.

  This module is created as part of Code Clinic challenge.
  """

  alias LPOStats.{Type, Weather, Stats}

  @stats Type.stats()

  @typedoc """
  `stats` represents statistic type returned by `get_*` function.
  """
  @type stats :: %{
    required(:mean) => float(),
    required(:median) => float(),
  }

  @doc """
  Get weather data from a CSV file into list of `t:LPOStats.Weather.t/0`.
  Returns `{:ok, weathers}` if CSV file is valid, returns `{:error, exception}` otherwise.

  List of possible exception:
  - `File.Error` if the file can not be opened.
  - `ArgumentError` if the file has invalid content format.

  ## CSV Examples
  Data can be taken from [this link](https://github.com/lyndadotcom/LPO_weatherdata).

  ```
  date       time    	Air_Temp	Barometric_Press	Dew_Point	Relative_Humidity	Wind_Dir	Wind_Gust	Wind_Speed
  2015_01_01 00:02:43	19.50	30.62	14.78	81.60	159.78	14.00	 9.20
  2015_01_01 00:02:52	19.50	30.62	14.78	81.60	159.78	14.00	 9.20
  ```

  ## Example
      iex> file_path = "#{__DIR__}/../test/testdata/test_data_for_get_weathers.txt"
      iex> LPOStats.load_weathers(file_path)
      {
        :ok,
        [
          %LPOStats.Weather{
            date: ~D[2015-01-01],
            time: ~T[00:02:43],
            air_temp: 19.50,
            barometric_press: 30.62,
            dew_point: 14.78,
            relative_humidity: 81.60,
            wind_dir: 159.78,
            wind_gust: 14.00,
            wind_speed: 9.20
          },
          %LPOStats.Weather{
            date: ~D[2015-01-01],
            time: ~T[00:07:43],
            air_temp: 19.50,
            barometric_press: 30.61,
            dew_point: 14.66,
            relative_humidity: 81.20,
            wind_dir: 155.63,
            wind_gust: 11.00,
            wind_speed: 8.60
          }
        ]
      }
  """
  @spec load_weathers(Path.t()) :: {:ok, list(Weather.t())} | {:error, Exception.t()}
  def load_weathers(file_path) do
    try do
      {:ok, Weather.get_weathers!(file_path)}
    rescue
      exception -> {:error, exception}
    end
  end

  Enum.each(@stats, fn stat ->
    @doc """
    Returns **#{stat}** statistic.
    """
    @spec unquote(:"get_#{stat}")(list(Weather.t())) :: stats
    def unquote(:"get_#{stat}")(weathers) do
      {count, sum, list} = Stats.get_raw_stats(weathers, unquote(stat))

      %{
        mean: Stats.get_mean(sum, count),
        median: Stats.get_median(count, list)
      }
    end
  end)
end
