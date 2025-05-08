defmodule Util.MySigils do
  def sigil_n(string, modifiers)

  # Force float with modifier "f"
  def sigil_n(string, [?f]) do
    String.to_float(String.trim(string))
  end

  # Force integer with modifier "i"
  def sigil_n(string, [?i]) do
    String.to_integer(String.trim(string))
  end

  # Auto-detect number type
  def sigil_n(string, []) do
    case parse_number(string) do
      {:ok, value} -> value
      {:error, reason} -> raise ArgumentError, reason
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
        {:error, "Invalid numeric value: #{string}"}
    end
  end
end
