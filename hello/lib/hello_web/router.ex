defmodule HelloWeb.Router do
  use HelloWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Full page layout: lib/hello_web/templates/layout/app.html.eex
  # view route command **mix phx.routes**
  scope "/", HelloWeb do
    pipe_through :browser
    # get is a macro.
    # Below expands to def match(:get, "/", PageController, :index, [])
    get "/", PageController, :index
    get "/hello", HelloController, :index
    get "/hello/:text", HelloController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", HelloWeb do
  #   pipe_through :api
  # end
end
