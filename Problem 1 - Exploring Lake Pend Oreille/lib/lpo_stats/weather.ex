defmodule LPOStats.Weather do
  @moduledoc """
  Weather provides functions to interact with weather data.
  """

  import LPOStats.Type

  alias Util.VerboseParsing

  @stats stats()

  # [Learning note] enforce_keys is a module attribute to
  # make struct fields required.
  @enforce_keys [
    :date,
    :time
  ]

  # [Learning note] struct is built on top of a map with compile time check and default value.
  # Its name is derived from the module name.
  @doc false
  defstruct @enforce_keys ++ Enum.map(@stats, &{&1, 0.0})

  @typedoc """
  Weather represents a raw weather data for a given date and time.

  ## Required fields

    * `date` - The calendar date when the measurement was taken. (`Date`)
    * `time` - The time of day when the measurement was taken. (`Time`)

  ## Optional fields

    * `air_temp` - The air temperature in degrees Celsius. (`t:float/0`, default: `0.0`)
    * `barometric_press` - The atmospheric pressure in millibars (hPa). (`t:float/0`, default: `0.0`)
    * `dew_point` - The temperature at which air becomes saturated with moisture. (`t:float/0`, default: `0.0`)
    * `relative_humidity` - The relative humidity as a percentage. (`t:float/0`, default: `0.0`)
    * `wind_dir` - The direction of the wind in degrees (0–360°). (`t:float/0`, default: `0.0`)
    * `wind_gust` - The maximum instantaneous wind speed during the measurement period. (`t:float/0`, default: `0.0`)
    * `wind_speed` - The average wind speed during the measurement period. (`t:float/0`, default: `0.0`)
  """
  weather_struct_type()

  @spec get_weathers!(Path.t()) :: list(t())
  def get_weathers!(file_path) do
    file_path
    |> File.stream!()
    # skip header
    |> Stream.drop(1)
    |> Stream.map(&parse_line/1)
    |> Enum.to_list()
  end

  defp parse_line(line) do
    line
    |> String.trim()
    # [Learning note] Regex:
    #   \s -> any white space (space, tab, newline)
    #   + -> any occurances
    |> String.split(~r/\s+/, trim: true)
    |> build_struct()
  end

  defp build_struct([date_str, time_str | stat_values]) do
    stat_data = Enum.zip(@stats, stat_values)
    |> Enum.map(
      fn {field, val} ->
        {field, VerboseParsing.to_float!(val, Atom.to_string(field))}
      end)
    |> Enum.into(%{})

    %__MODULE__{
      date: parse_date!(date_str),
      time: Time.from_iso8601!(time_str)
    }
    |> Map.merge(stat_data)
  end

  # [Learning note] Binary pattern matching.
  defp parse_date!(<<y::binary-size(4), "_", m::binary-size(2), "_", d::binary-size(2)>>) do
    Date.new!(
      VerboseParsing.to_integer!(y, "date-year"),
      VerboseParsing.to_integer!(m, "date-month"),
      VerboseParsing.to_integer!(d, "date-day")
    )
  end
end
