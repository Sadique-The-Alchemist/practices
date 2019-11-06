defmodule Typescale do
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

defmodule TypescaleLt do
  @moduledoc """
  Week #1 Exercise -> Typescale calculation using list of tuples
  """
  @listofTuples [{:h1, 4}, {:h2, 3}, {:h3, 2}, {:h4, 1}, {:p, 0}]
  @doc """
  arguments->map,base font,scale //calculate the font sizes of 4 heading by listofTuples base size scale and populate to a map
  and function overloading used to act on without list, empty list, list with tuples
  """
  @type base_font :: number
  @type scale :: number
  @spec calculate_fonts(map, base_font, scale) :: map
  def calculate_fonts(map, base_font, scale) do
    calculate_fonts(@listofTuples, map, base_font, scale)
  end

  def calculate_fonts([], map, base_font, scale) do
    Map.put(map, :p, base_font)
  end

  def calculate_fonts([head | tail], map, base_font, scale) do
    {heading_key, head_level} = head
    font_size = base_font * :math.pow(scale, head_level)
    map = Map.put(map, heading_key, font_size)
    calculate_fonts(tail, map, base_font, scale)
  end
end
