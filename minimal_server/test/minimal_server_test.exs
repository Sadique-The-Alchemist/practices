defmodule MinimalServerTest do
  use ExUnit.Case
  doctest Colors

  test "color_map by 10 steps create 10 variations" do
    map_legth = map_size(Colors.color_map("#1234ff", "#ff1234", 10))
    assert map_legth == 10
  end

  test "the weather returns a string contains temprature" do
    temp = HtmlParser.weather("india", "bangalore")
    assert String.length(temp) > 0
    end
end
