defmodule Unicorn.Users.Purchase do
  @moduledoc """
  Models purchases the user can make
  """

  alias Unicorn.Users.User

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
        "code_rate" => 100,
        "bug_rate" => 10,
        "expense_rate" => 100
      },
      "hacker" => %{
        "code_rate" => 200,
        "bug_rate" => 5,
        "expense_rate" => 300
      },
      "rockstar" => %{
        "code_rate" => 500,
        "bug_rate" => 1,
        "expense_rate" => 800
      },
      "ninja" => %{
        "code_rate" => 1000,
        "bug_rate" => -1,
        "expense_rate" => 2000
      }
    }
  }

  def available_purchases() do
    Enum.flat_map(@purchases, fn {type, items} ->
      Enum.map(items, fn {name, data} ->
        Map.merge(data, %{"type" => type, "name" => name})
      end)
    end)
  end

  def get(type, name) do
    case get_in(@purchases, [type, name]) do
      nil -> {:error, "that item doesn't exist"}
      item -> {:ok, Map.merge(@base_purchase, item)}
    end
  end

  def validate_cost(user, %{"cost" => 0, "expense_rate" => item_expense_rate}) do
    if item_expense_rate > 0 and user.money <= 0 and user.expense_rate > user.revenue_rate do
      {:error, "not enough income"}
    else
      :ok
    end
  end

  def validate_cost(%User{money: money}, %{"cost" => cost}) do
    if money >= cost do
      :ok
    else
      {:error, "not enough money"}
    end
  end

  def execute(%User{} = user, %{type: type, name: name}) do
    with {:ok, item} <- get(type, name),
         :ok <- validate_cost(user, item) do
      process_item_data(user, type, name, item)
    else
      err -> err
    end
  end

  def process_item_data(user, type, name, item) do
    %{
      code_rate: user.code_rate + item["code_rate"],
      bug_rate: user.bug_rate + item["bug_rate"],
      revenue_rate: user.revenue_rate + item["revenue_rate"],
      expense_rate: user.expense_rate + item["expense_rate"],
    }
    |> Map.merge(process_item_type_data(user, type, name, item))
  end

  def process_item_type_data(user, "employee", name, _item) do
    %{employees: user.employees}
    |> update_in([:employees, name], fn
      nil -> 1
      employee_count -> employee_count + 1
    end)
  end
end
