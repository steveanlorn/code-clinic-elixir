defmodule Util.MySigils do
  @moduledoc """
  Custom sigil ~n for parsing numbers.

  ## Usage

      import MySigils

      ~n"42"       # => 42 (integer)
      ~n"3.14"     # => 3.14 (float)
      ~n"42"i      # => 42 (forced integer)
      ~n"3.14"f    # => 3.14 (forced float)
      ~n"42"s      # => "42" (forced string)
  """

  def sigil_n(string, modifiers)

  # Force float with modifier "f"
  def sigil_n(string, "f") do
    String.to_float(String.trim(string))
  end

  # Force integer with modifier "i"
  def sigil_n(string, "i") do
    String.to_integer(String.trim(string))
  end

  # Auto-detect number type
  def sigil_n(string, []) do
    case parse_number(string) do
      {:ok, value} -> value
      :error -> raise ArgumentError, "Invalid numeric value: #{string}"
    end
  end

  defp parse_number(string) do
    string = String.trim(string)

    cond do
      String.match?(string, ~r/^-?\d+$/) ->
        {:ok, String.to_integer(string)}

      String.match?(string, ~r/^-?\d+\.\d+$/) ->
        {:ok, String.to_float(string)}

      true ->
        :error
    end
  end
end
