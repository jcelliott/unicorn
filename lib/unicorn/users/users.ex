defmodule Unicorn.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  require Logger
  alias Unicorn.Repo
  alias Unicorn.Users.User
  alias Unicorn.Users.UserProcess
  alias Unicorn.Users.UserProcessSupervisor
  alias Unicorn.Users.Action

  @doc """
  Returns the list of users.
  """
  def list_users do
    Repo.all(User)
  end

  def list_users(args) do
    sort_by = case args[:sort_by] do
      nil -> :money
      key when is_atom(key) -> key
      key when is_binary(key) -> String.to_existing_atom(Macro.underscore(key))
    end
    limit = args[:limit] || 10
    query = from User,
      order_by: [desc: ^sort_by],
      limit: ^limit
    Repo.all(query)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.
  """
  def get!(id), do: Repo.get!(User, id) |> merge_updates()

  def get(id) do
    case Repo.get(User, id) do
      nil -> {:error, "user does not exist"}
      user -> {:ok, user |> merge_updates()}
    end
  end

  def get_by_username!(username) do
    Repo.get_by!(User, username: username) |> merge_updates()
  end

  @doc """
  Creates a user.
  """
  def create_user(attrs \\ %{}) do
    attrs = Map.put_new(attrs, :money, 100000)
    %User{}
    |> User.create_changeset(attrs)
    |> IO.inspect(label: "create user")
    |> Repo.insert()
    |> ensure_user_process_started()
  end

  defp ensure_user_process_started({:error, _changeset} = result), do: result
  defp ensure_user_process_started({:ok, %User{} = user}), do: ensure_user_process_started(user)

  defp ensure_user_process_started(%User{} = user) do
    case UserProcessSupervisor.ensure_started(user.id) do
      {:ok, _user_id} -> {:ok, user}
      err -> err
    end
  end

  @doc """
  User performs an action
  """
  def execute_action(user, action) do
    case Action.execute(user, action) do
      {:ok, change_data} -> update_game_data(user, change_data)
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Updates a user's game data
  """
  def update_game_data(%User{} = user, data) do
    IO.puts("update: #{inspect data}")
    with updates <- calculate_updates(user),
         changeset <- User.changeset(user, Map.merge(updates, data)),
         {:ok, user} <- Repo.update(changeset),
         {:ok, _user} <- ensure_user_process_started(user),
         {:ok, :updated} <- UserProcess.update_game_data(user.id, user) do
      {:ok, user}
    else
      err -> IO.inspect(err)
      # _ -> {:error, "unable to update user game data"}
    end
  end

  @doc """
  Deletes a User.
  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.
  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def merge_updates(%User{} = user) do
    Map.merge(user, calculate_updates(user))
  end

  def calculate_updates(%User{} = user) do
    time_delta = NaiveDateTime.diff(NaiveDateTime.utc_now(), user.updated_at)
    %{
      money: user.money + ((user.revenue_rate - user.expense_rate) * time_delta),
      code: user.code + (user.code_rate * time_delta),
      bugs: user.bugs + (user.bug_rate * time_delta)
    }
  end
end
