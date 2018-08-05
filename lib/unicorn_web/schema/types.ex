defmodule UnicornWeb.Schema.Types do
  use Absinthe.Schema.Notation

  object :user do
    field :id, :id
    field :username, :string
    field :game_data, :game_data
  end

  object :game_data do
    field(:code, :float)
    field(:code_rate, :float)
    field(:bugs, :float)
    field(:bug_rate, :float)
    field(:money, :float)
    field(:revenue_rate, :float)
    field(:expense_rate, :float)
    field(:capacity, :integer)
    field(:employees, :employee_map)
    # field(:upgrades, :upgrade_map)
  end

  object :employee_map do
    field(:dev_intern, :employee)
    field(:hacker, :employee)
  end

  object :employee do
    field(:cost, :float)
    field(:code_rate, :float)
    field(:expense_rate, :float)
    field(:revenue_rate, :float)
    field(:bug_rate, :float)
  end
end
