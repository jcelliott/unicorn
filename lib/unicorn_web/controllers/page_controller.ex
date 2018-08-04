defmodule UnicornWeb.PageController do
  use UnicornWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
