defmodule Unicorn.Users.Purchase do
  @moduledoc """
  Models purchases the user can make
  """

  alias Unicorn.Users.GameData

  @base_purchase %{
    "cost" => 0,
    "expense_rate" => 0,
    "code_rate" => 0,
    "bug_rate" => 0,
    "revenue_rate" => 0
  }

  @purchases %{
    "employee" => %{
      "dev_intern" => %{
        "code_rate" => 1.0,
        "bug_rate" => 0.1,
        "expense_rate" => 100
      },
      "hacker" => %{
        "code_rate" => 5.0,
        "bug_rate" => 0.05,
        "expense_rate" => 500
      }
    }
  }

  def get(type, name) do
    case get_in(@purchases, [type, name]) do
      nil -> {:error, "that item doesn't exist"}
      item -> {:ok, Map.merge(@base_purchase, item)}
    end
  end

  def validate_cost(data, %{"cost" => 0, "expense_rate" => item_expense_rate}) do
    if item_expense_rate > 0 and data.money <= 0 and data.expense_rate > data.revenue_rate do
      {:error, "not enough income"}
    else
      :ok
    end
  end

  def validate_cost(%GameData{money: money}, %{"cost" => cost}) do
    if money >= cost do
      :ok
    else
      {:error, "not enough money"}
    end
  end

  def execute(%GameData{} = data, %{"type" => type, "name" => name}) do
    with {:ok, item} <- get(type, name),
         :ok <- validate_cost(data, item) do
      data
      |> process_item_data(type, name, item)
    else
      err -> err
    end
  end

  def process_item_data(data, type, name, item) do
    %{
      code_rate: data.code_rate + item["code_rate"],
      bug_rate: data.bug_rate + item["bug_rate"],
      revenue_rate: data.revenue_rate + item["revenue_rate"],
      expense_rate: data.expense_rate + item["expense_rate"],
    }
    |> Map.merge(process_item_type_data(data, type, name, item))
    # data
    # |> update_in([:code_rate], &(&1 + item.code_rate))
    # |> update_in([:bug_rate], &(&1 + item.bug_rate))
    # |> update_in([:revenue_rate], &(&1 + item.revenue_rate))
    # |> update_in([:expense_rate], &(&1 + item.expense_rate))
    # |> process_item_type_data(type, name, item)
  end

  def process_item_type_data(data, "employee", name, item) do
    # data
    # |> update_in([:employees, name], fn
    #   nil -> Map.merge(item, %{name: name, count: 1})
    #   employee -> %{employee | count: employee.count + 1}
    # end)
    employee = case data.employees[name] do
      nil -> Map.merge(Map.from_struct(item), %{"name" => name, "count" => 1})
      employee -> %{employee | "count" => employee["count"] + 1}
    end
    %{employees: Map.put(data.employees, name, employee)}
  end
end
