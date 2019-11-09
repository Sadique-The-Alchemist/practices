defmodule TypescaleExercise1 do
  @moduledoc """
  Week #1 Exercise -> calculate the font size of given list of headings.
  """
  @doc """
  arguments -> map, heading,base font, scale // calculate font sizes and put into a map by base size and scale // 
  :math.pow(s,h) to calculate h th power of s  
  """
  @type heading :: integer
  @type base_font :: number
  @type scale :: number

  @spec calculate_fonts(map, heading, base_font, scale) :: map
  def calculate_fonts(map, 0, base_font, scale) do
    Map.put(map, :p, base_font)
  end

  def calculate_fonts(map, heading, base_font, scale) do
    font_size = base_font * :math.pow(scale, heading)
    map = Map.put(map, heading, font_size)
    heading = heading - 1
    calculate_fonts(map, heading, base_font, scale)
  end
end
