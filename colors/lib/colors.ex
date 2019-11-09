defmodule Colors do
  @moduledoc """
  Project colors-> project to generate hexcodes of dark and light versions of a given color by mixing dark and light respectively
  """

  import CssColors
  @ranges [1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, 0.3, 0.2, 0.1]
  @doc """
  it expects a string of hexcode of a color and it delegates to_black and to_white functions map of black and white
  variations
  """
  def b_w_variations(color) do
    Map.put(%{}, :black, to_dark(color))
    |> Map.put(:light, to_light(color))
  end

  @doc """
  it expects a strings of excodes of primary and secondary colors and number of steps and it returns map contains primary to seconday variations
  """
  def color_map(primary, secondary, steps) do
    ranges = 1..steps
    # fragments = Enum.map(ranges, &(&1 * 0.01 * steps))

    Stream.map(ranges, &mix(parse!(primary), parse!(secondary), &1 * 1 / steps))
    |> color_strem_map
  end

  @doc """
  it return a map of 10 darkened variations of given color by CssColors.mix/3 function in a stream and used parse!/1 for string
   to rgb and used rgb/1 for hsl to rgb and to_strign/1 for rgb to hex code and wrapped each element to atuple alongside with index 
   and converted to a map by Enum.reduce and 
  """
  def to_dark(color) do
    pcolor = parse!(color)
    dcolor = parse!("#000000")

    Stream.map(@ranges, &mix(pcolor, dcolor, &1))
    |> color_strem_map
  end

  def to_light(color) do
    pcolor = parse!(color)
    dcolor = parse!("#ffffff")

    Stream.map(Enum.reverse(@ranges), &mix(pcolor, dcolor, &1))
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
