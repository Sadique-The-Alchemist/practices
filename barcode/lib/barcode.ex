defmodule Barcode do
  @doc """
  it expect a string as input and create barcode image in svg format at /tmp/barcode.svg 
  """
  def bc_encode(bcode) do
    Barlix.Code128.encode!(bcode)
    |> Barlix.SVG.print(file: "/tmp/barcode.svg", height: 20)
  end

  @doc """
  it expencts a qrcode content as input and create its corresponding qr code image on /tmp/qrc.svg
  """
  def qr_encode(qr_code_content) do
    qrcode_svg = qr_code_content |> EQRCode.encode() |> EQRCode.svg()
    File.write("/tmp/qrc.svg", qrcode_svg, [:binary])
  end
end
