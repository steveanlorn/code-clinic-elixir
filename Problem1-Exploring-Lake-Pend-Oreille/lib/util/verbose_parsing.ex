defmodule Util.VerboseParsing do
  @moduledoc false

  @spec to_float!(String.t(), String.t()) :: float()
  def to_float!(value, field) when is_binary(value) do
    try do
      String.to_float(value)
    rescue
      ArgumentError ->
        raise ArgumentError,
          message: "#{field} should be a textual representation of a float, but got: #{value}"
    end
  end

  @spec to_integer!(String.t(), String.t()) :: integer()
  def to_integer!(value, field) when is_binary(value) do
    try do
      String.to_integer(value)
    rescue
      ArgumentError ->
        raise ArgumentError,
          message: "#{field} should be a textual representation of a integer, but got: #{value}"
    end
  end
end
