defmodule HtmlParser do
  def weather(country, city) do
    [{"div", [{"class", "h2"}], [temprature]}] =
      HTTPoison.get!("https://www.timeanddate.com/weather/#{country}/#{city}").body
      |> Floki.find("div.h2")

    temprat(temprature)
  end

  def temprat(temprature) do
    temprature
  end
end
