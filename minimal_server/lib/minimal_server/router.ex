defmodule MinimalServer.Router do
  @moduledoc """
  a plug responsible for loading request info and parsing request parameters and creating responces 


  """
  use Plug.Router
  plug(:match)
  plug(:dispatch)

  @content_type "application/json"
  @primary "primary"
  @secondary "secondary"
  @steps "steps"
  @prefix "#"
  @country "country"
  @city "city"
  @input "input"
  @result "result"
  @country "country"
  @city "city"
  @doc """
  home screen
  """
  get "/" do
    conn
    |> put_resp_content_type(@content_type)
    |> send_resp(200, message())
  end

  @doc """
  return weather by country and city by message/2 function
  """
  get "/weather" do
    conn
    |> fetch_query_params

    {status, body} =
      case conn.query_params do
        %{@country => country, @city => city} ->
          {200, Poison.encode!(message(country, city))}

        _ ->
          {422, missing_data}
      end

    conn
    |> put_resp_content_type(@content_type)
    |> send_resp(status, body)
  end

  @doc """
  returns a map with variations of colors by get request primary, secondary and steps argument by function message/3 
  """
  get "/simple" do
    conn
    |> fetch_query_params

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

  @doc """
  returns a map with variations of colors by post request primary, secondary and steps argument by function message/3 
  """
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

  get "/log" do
    {:ok, index} = Redix.command(:redix, ["GET", "index"])
    ix = String.to_integer(index)
    range = 1..ix
    data = Enum.map(range, &logs(&1))

    {status, body} = {200, Poison.encode!(data)}

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

  defp message(country, city) do
    %{country: country, city: city, temprature: HtmlParser.weather(country, city)}
    Redix.command(:redix, ["HMSET", "weather_#{city}", @country, country, @city, city])
  end

  defp index do
  end

  defp message(primary, secondary, steps) do
    {:ok, i} = Redix.command(:redix, ["INCR", "index"])

    map =
      Colors.color_map(
        "#{@prefix}#{primary}",
        "#{@prefix}#{secondary}",
        String.to_integer(steps)
      )

    Redix.command(:redix, [
      "HMSET",
      "mixer_#{i}",
      @input,
      Poison.encode!(
        %{}
        |> Map.put(@primary, "#{@prefix}#{primary}")
        |> Map.put(@secondary, "#{@prefix}#{secondary}")
        |> Map.put(@steps, steps)
      ),
      @result,
      Poison.encode!(map)
    ])

    case map do
      %{} ->
        %{
          response: "Done",
          colors: map
        }

      _ ->
        %{response: "Error", message: "Check input values"}
    end
  end

  defp missing_data do
    Poison.encode!(%{
      error: "Expected Payload: { 'primary': '#0fs..','secondary': '#00f..','steps','1..' }"
    })
  end

  defp logs(id) do
    {:ok, contents} = Redix.command(:redix, ["HGETALL", "mixer_#{id}"])

    decode(%{}, contents)
  end

  defp decode(map, []) do
    map
  end

  defp decode(map, [head | tail]) do
    case head do
      @input ->
        create_map(tail, map, @input)

      @result ->
        create_map(tail, map, @result)

      _ ->
        decode(map, tail)
    end
  end

  defp create_map([head | tail], map, key) do
    Map.put(map, key, Poison.decode!(head))
    |> decode(tail)
  end

  match _ do
    send_resp(conn, 404, "Requested page not found!")
  end
end
