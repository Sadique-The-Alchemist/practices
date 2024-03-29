defmodule MinimalServer.Endpoint do
  use Plug.Router
  use Plug.Debugger
  use Plug.ErrorHandler
  alias MinimalServer.Router
  alias Plug.{Cowboy, HTML}
  require Logger
  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison
  )

  plug(:dispatch)

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  def start_link(_opts) do
    with {:ok, [port: port] = config} <- Application.fetch_env(:minimal_server, __MODULE__) do
      Logger.info("Starting server at http://localhost:#{port}/")
      Plug.Cowboy.http(__MODULE__, [], config)
    end
  end

  forward("", to: Router)

  # match _ do
  #   send_resp(conn, 404, "Requested page not found! ")
  # end

  match _ do
    conn
    |> send_resp(302, redirect_body())
  end

  defp redirect_body do
    ~S(<html><body>You are being <a href=")
    |> Kernel.<>(HTML.html_escape(redirect_url()))
    |> Kernel.<>(~S(">redirected</a>.</body></html>))
  end

  defp config, do: Application.fetch_env(:minimal_server, __MODULE__)
  defp redirect_url, do: Application.get_env(:minimal_server, :redirect_url)

  def handle_errors(%{status: status} = conn, %{kind: _kind, reason: _reason, stack: _stack}),
    do: send_resp(conn, status, "Something went wrong")
end
