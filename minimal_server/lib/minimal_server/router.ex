defmodule MinimalServer.Router do
  use Plug.Router
  plug(:match)
  plug(:dispatch)

  @content_type "application/json"
  get "/" do
    conn
    |> put_resp_content_type(@content_type)
    |> send_resp(200, message())
  end

  @primary "primary"
  @secondary "secondary"
  @steps "steps"
  @prefix "#"

  get "/simple" do
    conn
    |> fetch_query_params

    # conn.query_params
    {status, body} =
      case conn.query_params do
        %{@primary => primary, @secondary => secondary, @steps => steps} ->
          {200, Poison.encode!(message(primary, secondary, steps))}

        _ ->
          {422, missing_data}
      end

    conn
    |> put_resp_content_type(@content_type)
    |> send_resp(status, body)
  end

  post "/mix" do
    {status, body} =
      case conn.body_params do
        %{"primary" => primary, "secondary" => secondary, "steps" => steps} ->
          {200, Poison.encode!(message(primary, secondary, steps))}

        _ ->
          {422, missing_data}
      end

    conn
    |> put_resp_content_type(@content_type)
    |> send_resp(status, body)
  end

  defp message do
    Poison.encode!(%{
      response_type: "in_channel",
      text: "Hello from BOT :)"
    })
  end

  defp message(primary, secondary, steps) do
    %{
      response_type: "in_channel",
      colors:
        Colors.color_map(
          "#{@prefix}#{primary}",
          "#{@prefix}#{secondary}",
          String.to_integer(steps)
        )
    }
  end

  defp missing_data do
    Poison.encode!(%{
      error: "Expected Payload: { 'primary': '#0fs..','secondary': '#00f..','steps','1..' }"
    })
  end

  match _ do
    send_resp(conn, 404, "Requested page not found!")
  end
end
