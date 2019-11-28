defmodule HtmlParser do
  @moduledoc """
  a module to find weather by country and city from  https://www.timeanddate.com/weather/ and it will return the temprature if exact names provided

  """
  @doc """
  function to retrive temprature of weather by given country and city
  """
  def weather(country, city) do
    fetched_weather =
      HTTPoison.get!("https://www.timeanddate.com/weather/#{country}/#{city}").body
      |> Floki.find("div.h2")

    case fetched_weather do
      [{"div", [{"class", "h2"}], [temprature]}] ->
        temprat(temprature)

      _ ->
        error
    end
  end

  defp temprat(temprature) do
    temprature
  end

  defp error do
    "invalied country or city"
  end
end
