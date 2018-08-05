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

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.
  """
  def get!(id), do: Repo.get!(User, id)

  def get(id) do
    case Repo.get(User, id) do
      nil -> {:error, "user does not exist"}
      user -> {:ok, user}
    end
  end

  def get_by_username!(username) do
    Repo.get_by!(User, username: username)
  end

  @doc """
  Creates a user.
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.create_changeset(attrs)
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
  def execute_action(user_id, action) do
    with {:ok, user} <- get(user_id),
         {:ok, change_data} <- Action.execute(user.game_data, action) do
      update_game_data(user, change_data)
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Updates a user's game data
  """
  def update_game_data(%User{} = user, data) do
    with {:ok, _user} <- ensure_user_process_started(user),
         {:ok, :updated} <- UserProcess.update_game_data(user.id, data),
         changeset <- User.changeset(user, %{game_data: data}),
         {:ok, user} <- Repo.update(changeset) do
      {:ok, user}
    else
      _ -> {:error, "unable to update user game data"}
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
end
