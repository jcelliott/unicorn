defmodule UnicornWeb.Schema.Types do
  use Absinthe.Schema.Notation

  object :user do
    field :id, non_null(:id)
    field :username, non_null(:string)
    field :game_data, :game_data
  end

  object :game_data do
    field(:code, :integer)
    field(:code_rate, :integer)
    field(:bugs, :integer)
    field(:bug_rate, :integer)
    field(:money, :integer)
    field(:revenue_rate, :integer)
    field(:expense_rate, :integer)
    field(:capacity, :integer)
    field(:employees, :employee_map)
    # field(:upgrades, :upgrade_map)
  end

  object :employee_map do
    field(:dev_intern, :integer)
    field(:hacker, :integer)
  end

end
