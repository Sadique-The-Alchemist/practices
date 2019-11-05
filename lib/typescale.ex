defmodule Typescale do
  @moduledoc """
  Week #1 Exercise -> calculate the font size of given list of headings.
  """
  @doc """
  arguments -> map, heading,base font, scale // calculate font sizes and put into a map by base size and scale // 
  :math.pow(s,h) to calculate h th power of s  
  """

  def calculate_fonts(map, 0, b, s) do
    Map.put(map, :p, b)
  end

  def calculate_fonts(map, h, b, s) do
    p = b * :math.pow(s, h)
    map = Map.put(map, h, p)
    h = h - 1
    fonts(map, h, b, s)
  end
end
