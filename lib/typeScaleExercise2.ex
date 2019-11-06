defmodule TypescaleExercise2 do
  @moduledoc """
  Week #1 Exercise -> Typescale calculation using list of tuples
  """
  @listofTuples [{:h1, 4}, {:h2, 3}, {:h3, 2}, {:h4, 1}, {:p, 0}]
  @resultList []
  @doc """
  arguments->list,base font,scale //calculate the font sizes of 4 heading by listofTuples base size,scale and populate to a list of tuples
  and used tail call optimisation for bot empty and non empty tails
  data inserted to result list by List.insert_at(list,index,value), and the index asigned by length/1 
  by recursion result list will be generated
  """
  @type base_font :: number
  @type scale :: number
  @spec calculate_fonts(base_font, scale) :: list
  def calculate_fonts(base_font, scale) do
    calculate_fonts(@listofTuples, @resultList, base_font, scale)
  end

  def calculate_fonts([], list, _base_font, _scale) do
    list
  end

  def calculate_fonts([head | tail], list, base_font, scale) do
    {heading_key, head_level} = head
    font_size = base_font * :math.pow(scale, head_level)
    index = length(list)
    list = List.insert_at(list, index, {heading_key, font_size})
    calculate_fonts(tail, list, base_font, scale)
  end

  @doc """
  arguments-> base_font, scale // creating a list of tuples of 4 heading sizes  by scale and base font
  Enum.map function used to create list of tuples by reference of attributes and parameters
  """
  @spec calculate_fonts_enum(base_font, scale) :: list
  def calculate_fonts_enum(base_font, scale) do
    Enum.map(@listofTuples, fn {k, v} -> {k, base_font * :math.pow(scale, v)} end)
  end
end
