defmodule UnicornWeb.Schema.Resolvers do
  alias Unicorn.Users

  def get_current_user(_args, _resolution) do
    {:ok, Users.get_by_username!("fred")}
  end
end
