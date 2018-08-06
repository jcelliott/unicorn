defmodule Unicorn.Users.LeaderboardUpdater do
  use GenServer
  alias Unicorn.Users
  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Process.send_after(self(), :work, 5 * 1000)
    {:ok, state}
  end

  def handle_info(:work, state) do
    Logger.debug("leaderboard update")
    leaders = Users.list_users(%{sort_by: :money, limit: 10})

    Absinthe.Subscription.publish(
      UnicornWeb.Endpoint,
      {:ok, leaders},
      leaderboard_updated: "updated"
    )

    # Call again
    Process.send_after(self(), :work, 5 * 1000)

    {:noreply, state}
  end
end
