defmodule UnicornWeb.Schema.Types do
  use Absinthe.Schema.Notation

  object :user do
    field :id, non_null(:id)
    field :username, non_null(:string)
    field(:code, :integer)
    field(:code_rate, :integer)
    field(:bugs, :integer)
    field(:bug_rate, :integer)
    field(:money, :integer)
    field(:revenue_rate, :integer)
    field(:expense_rate, :integer)
    field(:capacity, :integer)
    field(:employees, :employee_map)
    field(:upgrades, :upgrade_map)
  end

  object :employee_map do
    field(:dev_intern, :integer)
    field(:hacker, :integer)
  end

  object :upgrade_map do

  end

  object :purchase_item do
    field(:type, :string)
    field(:name, :string)
    field(:cost, :integer)
    field(:code_rate, :integer)
    field(:revenue_rate, :integer)
    field(:expense_rate, :integer)
  end

  # lookup fields in :employee_map by string keys instead of atoms
  def middleware(middleware, %{identifier: identifier} = field, %{identifier: id} = object) when id == :employee_map or id == :purchase_item do
    IO.puts("custom middleware here *****")
    middleware_spec = {{__MODULE__, :get_string_key}, Atom.to_string(identifier)}
    Absinthe.Schema.replace_default(middleware, middleware_spec, field, object)
  end
end
