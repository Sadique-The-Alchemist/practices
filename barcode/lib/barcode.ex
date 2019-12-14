defmodule Barcode do
  @doc """
  it expect a string as input and create barcode image in svg format at /tmp folder
  """
  def bc_encode(bcode) do
    Barlix.Code128.encode!(bcode)
    |> Barlix.SVG.print(file: "/tmp/barcode.svg", height: 20)
  end
end
