defmodule GenfileDownload do
  use GenServer

  def start_link(opts(/ / %{})) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def stop(pid), do: GenServer.cast(pid, :stop)

  def download_file(url, destination) do
    resp = HTTPoison.get!(url, %{}, stream_to: self(), async: :once)
    {:ok, fd} = File.open(destination, [:write, :binary])
    resp_id=resp.id
    GenServer.call(pid, {:download, {resp, fd}})
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call(%HTTPoison.AsyncStatus{code: status_code, id: ^resp_id}, _from, {resp, fd}) do
    IO.inspect(status_code)
    HTTPoison.stream_next(resp)
  end

  def handle_call(%HTTPoison.AsyncHeaders{headers: headers, id: ^resp_id}, _from, {resp, fd}) do
    IO.inspect(headers)
    HTTPoison.stream_next(resp)
  end

  def handle_call(%HTTPoison.AsyncChunk{chunk: chunk, id: ^resp_id}, _from, {resp, fd}) do
    IO.binwrite(fd, chunk)
    # accumulated_data = data <> chunk
    # accumulated_byte = byte_size(accumulated_data)
    # percent = (accumulated_byte / size * 100) |> Float.round(2)
    # IO.puts("#{percent} % (#{mb(accumulated_byte)}) Downloaded...")
    HTTPoison.stream_next(resp)
  end

  def handle_cast(%HTTPoison.AsyncEnd{id: ^resp_id}, fd)
  File.close(fd)
end
