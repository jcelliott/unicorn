defmodule UnicornWeb.Context do
  @behaviour Plug

  import Plug.Conn
  alias Unicorn.Users

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  @doc """
  Return the current user context.

  This would normally be where you do some form of authentication,
  but we're just faking it here.
  """
  def build_context(conn) do
    with [user_id] <- get_req_header(conn, "currentuserid"),
         {:ok, user} <- Users.get(user_id) do
      %{current_user: user}
    else
      _ -> %{}
    end
  end
end
