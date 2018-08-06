defmodule Unicorn.Users.Action do
  @moduledoc """
  Handles validating and executing actions a user can perform
  """

  alias Unicorn.Users.User
  alias Unicorn.Users.Purchase
  alias Unicorn.Users.Release

  def execute(%User{} = user, {:purchase, purchase}) do
    case Purchase.execute(user, purchase) do
      {:error, reason} -> {:error, reason}
      data -> {:ok, data}
    end
  end

  def execute(%User{} = user, :release) do
    case Release.execute(user) do
      {:error, reason} -> {:error, reason}
      data -> {:ok, data}
    end
  end
end
