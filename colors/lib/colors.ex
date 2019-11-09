defmodule Colors do
  @moduledoc """
  Project colors-> project to generate hexcodes of dark and light versions of a given color by mixing dark and light respectively
  """

  import CssColors
  @ranges [0.01, 0.04, 0.09, 0.16, 0.27, 0.36, 0.49, 0.64, 0.81, 1]
  @doc """
  it expects a string of hexcode of a color and it delegates to_black and to_white functions map of black and white
  variations
  """
  def b_w_variations(color) do
    Map.put(%{}, :black, to_dark(color))
    |> Map.put(:light, to_light(color))
  end

  @doc """
  it return a map of 10 darkened variations of given color by CssColors.darken/2 function in a stream and used parse!/1 for string
   to rgb and used rgb/1 for hsl to rgb and to_strign/1 for rgb to hex code and wrapped each element to atuple alongside with index 
   and converted to a map by Enum.reduce and 
  """
  def to_dark(color) do
    pcolor = parse!(color)

    Stream.map(@ranges, &darken(pcolor, &1))
    |> color_strem_map

    # |> Stream.map(&rgb(&1))
    # |> Stream.map(&to_string(&1))
    # |> Stream.with_index()
    # |> Enum.reduce(%{}, fn {v, k}, acc -> Map.put(acc, k, v) end)
  end

  def to_light(color) do
    pcolor = parse!(color)

    Stream.map(@ranges, &lighten(pcolor, &1))
    |> color_strem_map
  end

  def color_strem_map(stream) do
    stream
    |> Stream.map(&rgb(&1))
    |> Stream.map(&to_string(&1))
    |> Stream.with_index()
    |> Enum.reduce(%{}, fn {v, k}, acc -> Map.put(acc, k, v) end)
  end
end