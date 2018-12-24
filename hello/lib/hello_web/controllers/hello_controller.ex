defmodule HelloWeb.HelloController do
  use HelloWeb, :controller


  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"text" => text}) do
    # /templates/hello/show.html.eex
    api_key = Application.get_env(:hello, HelloWeb.Endpoint)[:api_key]
    input_params = conn.params
    default_params = [
          {"apikey", api_key},
          {"lang","en"},
          {"limit", "50"},
          {"text", text},
          {"pos", ""},
          {"indent", ""}
        ]
    merged_params = make_params(default_params, input_params)


    url = "https://api.wordassociations.net/associations/v1.0/json/search/"
    case HTTPoison.get(url, [], [params: merged_params] ) do
      {:ok, %{status_code: 200, body: body}} ->
        formatted_stuff = format_results(Poison.decode!(body))
        render(conn, "show.html", %{:text => text, :word_data => formatted_stuff})
      {:ok, %{status_code: 401}} ->
        render(conn, "error.html", %{:text => text, :code => "401", :error_message => "invalid api key"})
      {:ok, %{status_code: 429}} ->
        render(conn, "error.html", %{:text => text, :code => "429", :error_message => "The monthly limit on the number of requests is exceeded"})
      {:ok, %{status_code: 501}} ->
        render(conn, "error.html", %{:text => text, :code => "501", :error_message => "Specified language is not supported."})
      {:error, %{reason: reason}} ->
        render(conn, "error.html", %{:text => text, :code => "other", :error_message => reason})
    end
  end

  def  format_results(result_body) do
    get_in(result_body, ["response", Access.all(), "items"])
  end
  def make_params(default, input) do
    Enum.into(default, %{})
      |> Map.merge(input)
      |> Enum.map(fn{k,v} -> {k, v} end)
  end
end
