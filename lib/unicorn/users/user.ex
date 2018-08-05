defmodule Unicorn.Users.User do
  @moduledoc """
  Defines the User schema
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Unicorn.Users.GameData

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field(:username, :string)
    embeds_one(:game_data, GameData, on_replace: :update)
    # embeds_one(:game_data, GameData)

    timestamps()
  end

  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> validate_length(:username, min: 3)
    |> unique_constraint(:username)
    |> put_change(:game_data, %{})
  end

  # def changeset(user, %{game_data: %GameData{} = game_data}) do
  #   user
  #   |> change()
  #   |> put_change(:game_data, game_data)
  # end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [])
    |> cast_embed(:game_data)
  end
end
