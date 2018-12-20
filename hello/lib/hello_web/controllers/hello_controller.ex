defmodule HelloWeb.HelloController do
  use HelloWeb, :controller

  # conn = request data
  # the _ is to avoid compiler warnings
  def index(conn, _params) do
    # template in lib/hello_web/templates/hello
    render(conn, "index.html")
  end
  # multiple binds can be like show(conn, %{"messenger" => messenger} = params)
  def show(conn, %{"messenger" => messenger}) do
    # /templates/hello/show.html.eex
    render(conn, "show.html", messenger: messenger)
  end
end
