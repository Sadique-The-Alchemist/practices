defmodule MinimalServer.Router do
  use Plug.Router
  plug(:match)
  plug(:dispatch)

  post "/mix/:id" do
    {status, body} =
      case conn.body_params do
        %{"primary" => primary, "secondary" => secondary, "steps" => steps} ->
          {200, Poison.encode!(message(primary, secondary, steps))}

        _ ->
          {422, missing_data}
      end

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, body)
  end

  defp message(primary, secondary, steps) do
    %{
      response_type: "in_channel",
      colors: Colors.color_map(primary, secondary, String.to_integer(steps))
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
