defmodule Unicorn.Users.UserProcessSupervisor do
  @moduledoc """
  UserProcess keeps track of the user's current state.
  """

  use DynamicSupervisor
  require Logger
  alias Unicorn.Users.UserProcess

  @user_registry_name :user_registry

  def start_link() do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def ensure_started(user_id) do
    if user_process_exists?(user_id) do
      {:ok, user_id}
    else
      create_user_process(user_id)
    end
  end

  def user_process_exists?(user_id) do
    case Registry.lookup(@user_registry_name, user_id) do
      [] -> false
      _ -> true
    end
  end

  def create_user_process(user_id, data \\ %{}) do
    Logger.debug("creating user process: #{user_id}")
    spec = {UserProcess, [user_id: user_id, data: data]}

    case DynamicSupervisor.start_child(__MODULE__, spec) do
      {:ok, _pid} -> {:ok, user_id}
      {:error, {:already_started, _pid}} -> {:error, :process_already_exists}
      other -> {:error, other}
    end
  end

  @impl true
  def init(_) do
    Logger.debug("UserProcessSupervisor starting")
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
