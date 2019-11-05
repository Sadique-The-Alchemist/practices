defmodule Typescale do
  @moduledoc """
  Week #1 Exercise -> calculate the font size of given list of headings.
  """
  @doc """
  map, heading,base font, scale
  """

  def fonts(map, 0, b, s) do
    Map.put(map, :p, b)
  end

  def fonts(map, h, b, s) do
    p = b * :math.pow(s, h)
    map = Map.put(map, h, p)
    h = h - 1
    fonts(map, h, b, s)
  end
end
