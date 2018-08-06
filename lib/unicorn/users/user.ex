defmodule Unicorn.Users.User do
  @moduledoc """
  Defines the User schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field(:username, :string)
    field(:code, :integer, default: 0)
    field(:code_rate, :integer, default: 0)
    field(:bugs, :integer, default: 0)
    field(:bug_rate, :integer, default: 0)
    field(:money, :integer, default: 0)
    field(:revenue_rate, :integer, default: 0)
    field(:expense_rate, :integer, default: 0)
    field(:capacity, :integer, default: 1)
    field(:employees, :map, default: %{})
    field(:upgrades, :map, default: %{})

    timestamps()
  end

  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :money])
    |> validate_required([:username])
    |> validate_length(:username, min: 3)
    |> unique_constraint(:username)
  end

  @valid_update_fields ~w{code code_rate bugs bug_rate money revenue_rate expense_rate capacity employees upgrades}a
  def changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, @valid_update_fields)
  end
end
