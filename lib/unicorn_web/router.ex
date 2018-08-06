defmodule UnicornWeb.Router do
  use UnicornWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  scope "/", UnicornWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug UnicornWeb.Context
  end

  scope "/api" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: UnicornWeb.Schema,
      interface: :playground

    forward "/", Absinthe.Plug,
      schema: UnicornWeb.Schema
  end

end
