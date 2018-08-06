defmodule UnicornWeb.Router do
  use UnicornWeb, :router
  require Logger

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
    plug(:accepts, ["json"])
    plug(UnicornWeb.Context)
    plug(:debug_response)
  end

  scope "/api" do
    pipe_through(:api)

    forward(
      "/graphiql",
      Absinthe.Plug.GraphiQL,
      schema: UnicornWeb.Schema,
      interface: :playground
    )

    forward("/", Absinthe.Plug, schema: UnicornWeb.Schema)
  end

  defp debug_response(conn, _) do
    Plug.Conn.register_before_send(conn, fn conn ->
      if conn.status >= 400 do
        Logger.debug("Error response: #{inspect(Poison.decode!(conn.resp_body), pretty: true)}")
      end

      conn
    end)
  end
end
