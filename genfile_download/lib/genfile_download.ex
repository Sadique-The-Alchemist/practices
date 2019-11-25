defmodule GenfileDownload do
  @moduledoc """
  module to download a file from a url by HTTPoison.get/3 by using GenServer
  """
  @url "https://png.pngtree.com/png-clipart/20190515/original/pngtree-blue-vast-sky-png-and-psd-png-image_3547527.jpg"
  @destination "/tmp/image.jpg"
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(args) do
    {:ok, args}
  end

  def get_startingresponce(url) do
    GenServer.call(__MODULE__, {:get_starting, url})
  end

  def get_file do
    GenServer.cast(__MODULE__, {:download})
  end

  def handle_call({:get_starting, url}, _pid, state) do
    {:reply, url, state}
  end

  def handle_cast({:download}, state) do
    {:noreply, download_file(@url, @destination)}
  end

  @doc """
  it expects a get url and destination path to download file from url by HTTPoison.get!/3 , 
  it will create a process message by its PID and by receiving purticular structs the action to downlod will happend in receive do block
  """
  def download_file(url, destination) do
    async_download = fn resp, fd, download_fn, size, data ->
      resp_id = resp.id

      receive do
        %HTTPoison.AsyncStatus{code: status_code, id: ^resp_id} ->
          IO.inspect(status_code)
          HTTPoison.stream_next(resp)
          download_fn.(resp, fd, download_fn, size, data)

        %HTTPoison.AsyncHeaders{headers: headers, id: ^resp_id} ->
          headers_map = Enum.into(headers, %{})
          {content_length, _} = headers_map["Content-Length"] |> Integer.parse()
          IO.puts("The total Size is #{mb(content_length)}")
          IO.inspect(headers)
          HTTPoison.stream_next(resp)
          download_fn.(resp, fd, download_fn, content_length, data)

        %HTTPoison.AsyncChunk{chunk: chunk, id: ^resp_id} ->
          IO.binwrite(fd, chunk)
          accumulated_data = data <> chunk
          accumulated_byte = byte_size(accumulated_data)
          percent = (accumulated_byte / size * 100) |> Float.round(2)
          IO.puts("#{percent} % (#{mb(accumulated_byte)}) Downloaded...")
          HTTPoison.stream_next(resp)

          download_fn.(resp, fd, download_fn, size, accumulated_data)

        %HTTPoison.AsyncEnd{id: ^resp_id} ->
          File.close(fd)
      end
    end

    resp = HTTPoison.get!(url, %{}, stream_to: self(), async: :once)
    {:ok, fd} = File.open(destination, [:write, :binary])
    async_download.(resp, fd, async_download, :unknown, "")
  end

  defp mb(bytes) do
    number = (bytes / 1_048_576) |> Float.round(2)
    "#{number} MB"
  end
end
