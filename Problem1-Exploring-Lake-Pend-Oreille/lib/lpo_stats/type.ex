defmodule LPOStats.Type do
  @stats ~w(
    air_temp
    barometric_press
    dew_point
    relative_humidity
    wind_dir
    wind_gust
    wind_speed
  )a

  @type stat_field ::
  unquote(
    Enum.reduce(tl(@stats), hd(@stats), fn stat, acc ->
      quote do: unquote(stat) | unquote(acc)
    end)
  )

  @spec stats() :: list(stat_field())
  def stats, do: @stats

  @spec weather_struct_type() :: Macro.t
  defmacro weather_struct_type do
    base_fields = [
      date: quote(do: Date.t()),
      time: quote(do: Time.t())
    ]

    stat_fields =
      for stat <- @stats do
        {stat, quote(do: float())}
      end

    all_fields = base_fields ++ stat_fields

    quote do
      @opaque t :: %__MODULE__{
        unquote_splicing(all_fields)
      }
    end
  end
end
