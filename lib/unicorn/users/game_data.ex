defmodule Unicorn.Users.GameData do
  @moduledoc """
  Defines the GameData schema
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
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

  # adds Access behavior to the schema-derived struct
  use Accessible

  @valid_fields ~w{code code_rate bugs bug_rate money revenue_rate expense_rate capacity employees upgrades}a

  def changeset(game_data, attrs) do
    game_data
    |> cast(attrs, @valid_fields)
  end
end

