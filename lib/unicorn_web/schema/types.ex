defmodule UnicornWeb.Schema.Types do
  use Absinthe.Schema.Notation

  @desc "User object containing the game state"
  object :user do
    field(:id, non_null(:id))
    field(:username, non_null(:string))
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

  @desc "Map of employee names to counts"
  object :employee_map do
    field(:dev_intern, :integer, resolve: string_key("dev_intern"))
    field(:hacker, :integer, resolve: string_key("hacker"))
    field(:ninja, :integer, resolve: string_key("ninja"))
    field(:rockstar, :integer, resolve: string_key("rockstar"))
  end

  # object :upgrade_map do
  # end

  @desc "Details of an item that can be purchased"
  object :purchase_item do
    field(:type, :string, resolve: string_key("type"))
    field(:name, :string, resolve: string_key("name"))
    field(:cost, :integer, resolve: string_key("cost"))
    field(:code_rate, :integer, resolve: string_key("code_rate"))
    field(:revenue_rate, :integer, resolve: string_key("revenue_rate"))
    field(:expense_rate, :integer, resolve: string_key("expense_rate"))
  end

  def string_key(key) do
    fn obj, _, _ -> {:ok, obj[key]} end
  end

  # lookup fields in :employee_map by string keys instead of atoms
  def middleware(middleware, %{identifier: identifier} = field, %{identifier: id} = object)
      when id == :employee_map or id == :purchase_item do
    middleware_spec = {{__MODULE__, :get_string_key}, Atom.to_string(identifier)}
    Absinthe.Schema.replace_default(middleware, middleware_spec, field, object)
  end

  # if it's any other object keep things as is
  def middleware(middleware, _field, _object), do: middleware

  def get_string_key(%{source: source} = res, key) do
    %{res | state: :resolved, value: Map.get(source, key)}
  end
end
