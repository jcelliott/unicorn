defmodule Unicorn.Users.UserProcess do
  @moduledoc """
  UserProcess keeps track of the user's current state.
  """

  use GenServer, restart: :transient
  require Logger

  @user_registry_name :user_registry

  def start_link(user_id: user_id, data: data) do
    name = lookup_name(user_id)
    GenServer.start_link(__MODULE__, Map.merge(data, %{id: user_id}), name: name)
  end

  defp lookup_name(user_id) do
    {:via, Registry, {@user_registry_name, user_id}}
  end

  def update_game_data(user_id, data) do
    GenServer.call(lookup_name(user_id), {:update_game_data, data})
  end

  def get_game_data(user_id) do
    GenServer.call(lookup_name(user_id), :get_game_data)
  end

  @impl true
  def init(state) do
    Logger.debug("started user process: #{state.id}")
    {:ok, state}
  end

  @impl true
  def handle_call({:update_game_data, data}, _from, _state) do
    {:reply, {:ok, :updated}, data}
  end

  @impl true
  def handle_call(:get_game_data, _from, state) do
    {:reply, {:ok, state}, state}
  end
end
