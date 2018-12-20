defmodule HelloWeb.HelloController do
  use HelloWeb, :controller

  # conn = request data
  # the _ is to avoid compiler warnings
  def index(conn, _params) do
    # template in lib/hello_web/templates/hello
    render(conn, "index.html")
  end
end
