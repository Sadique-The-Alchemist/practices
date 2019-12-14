defmodule BarcodeTest do
  use ExUnit.Case
  doctest Barcode

  test "greets the world" do
    assert Barcode.hello() == :world
  end
end
