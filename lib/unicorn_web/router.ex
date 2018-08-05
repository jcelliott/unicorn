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

  forward "/api", Absinthe.Plug,
    schema: UnicornWeb.Schema

  forward "/graphiql", Absinthe.Plug.GraphiQL,
    schema: UnicornWeb.Schema,
    interface: :playground

end
